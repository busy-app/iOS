import SwiftUI

import ActivityKit

struct BusyView: View {
    @Binding var settings: BusySettings

    @State private var busy: BusyState = .init(.init())

    @State private var activity: Activity<BusyWidgetAttributes>?

    @Environment(\.appState) var appState

    var sounds: Sounds { .shared }

    var body: some View {
        Group {
            if let interval = busy.interval {
                if busy.state != .finished {
                    TimerView(
                        interval: interval,
                        busy: $busy,
                        settings: $settings
                    )
                } else {
                    if interval.kind == .work {
                        WorkDoneView(busy: $busy) {
                            busy.next()
                            busy.start()
                        }
                    } else {
                        RestOverView {
                            busy.next()
                            busy.start()
                        }
                    }
                }
            } else {
                FinishedView {
                    startBusy()
                } finish: {
                    appState.wrappedValue = .cards
                    sendState()
                }
            }
        }
        .onChange(of: busy.state) {
            updateActivity()
        }
        .onChange(of: busy.interval?.kind) {
            updateActivity()
        }
        .onChange(of: busy.interval) {
            if busy.interval == nil {
                stopActivity()
            }
        }
        .onChange(of: busy.interval?.remaining) {
            playSoundIfNeeded()
            feedbackIfNeeded()
        }
        .task {
            startBusy()
        }
        .onDisappear {
            BusyShield.disable()
            stopActivity()
        }
        .onReceive(Connectivity.shared.$busyState) { busyState in
            if let busyState {
                switch busyState.timerState {
                case .paused: busy.pause()
                case .running: busy.stop()
                case .finished: busy.stop()
                }

                busy.jump(to: busyState.interval, at: busyState.elapsed)

                if busyState.timerState == .running {
                    busy.start()
                }
            }
        }
    }

    func startBusy() {
        BusyShield.enable(settings.blocker)

        busy = .init(settings)
        BusyState.Holder.shared.set(busy)

        busy.start()
        startActivity()
        sendState()
    }

    func sendState() {
        Connectivity.shared.send(
            settings: settings,
            appState: appState.wrappedValue,
            busyState: .init(
                timerState: busy.state,
                interval: busy.intervals.index,
                elapsed: busy.interval?.elapsed ?? .seconds(0)
            )
        )
    }

    func playSoundIfNeeded() {
        guard let interval = busy.interval, !interval.isInfinite else {
            return
        }
        if settings.sound.intervals,
           interval.remaining >= .seconds(0),
           interval.remaining <= .seconds(3)
        {
            switch (interval.kind, interval.remaining) {
            case (.work, .seconds(0)): sounds.play(.workFinished)
            case (.work, _): sounds.play(.workCountdown)
            case (.rest, .seconds(0)): sounds.play(.restFinished)
            case (.rest, _): sounds.play(.restCountdown)
            default: break
            }
        } else if settings.sound.metronome, interval.elapsed > .seconds(0) {
            sounds.play(.metronome)
        }
    }

    func feedbackIfNeeded() {
        guard let interval = busy.interval else { return }

        if interval.remaining == .seconds(0) {
            UINotificationFeedbackGenerator().notificationOccurred(.success)
        }
    }
}

extension BusyView {
    var deadline: Date {
        .now.advanced(by: Double(busy.interval?.remaining.seconds ?? 0))
    }

    var contentState: BusyWidgetAttributes.ContentState {
        .init(
            state: busy.state,
            time: .now...deadline,
            kind: busy.interval?.kind ?? .work
        )
    }

    func startActivity() {
        self.activity = try? Activity<BusyWidgetAttributes>.request(
            attributes: .init(),
            content: .init(
                state: contentState,
                staleDate: deadline
            )
        )
    }

    func updateActivity() {
        let activity = self.activity
        Task {
            await activity?.update(
                .init(
                    state: contentState,
                    staleDate: deadline
                )
            )
        }
    }

    func stopActivity() {
        let activity = self.activity
        self.activity = nil
        Task {
            await activity?.end(.none, dismissalPolicy: .immediate)
        }
    }
}
