import SwiftUI

import ActivityKit
import AVFoundation

struct BusyView: View {
    @Binding var settings: BusySettings

    @State private var busy: BusyState = .init(.init())

    @State private var activity: Activity<BusyWidgetAttributes>?

    @State private var player: AVAudioPlayer?

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
                        TimerView.WorkDoneView(busy: $busy) {
                            busy.next()
                            busy.start()
                        }
                    } else {
                        TimerView.RestOverView {
                            busy.next()
                            busy.start()
                        }
                    }
                }
            } else {
                TimerView.FinishedView {
                    startBusy()
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
        }
        .task {
            startBusy()
        }
        .onDisappear {
            BusyShield.disable()
            stopActivity()
        }
    }

    func startBusy() {
        if settings.blocker.isOn {
            BusyShield.enable(settings.blocker)
        }

        busy = .init(settings)
        BusyState.Holder.shared.set(busy)

        busy.start()
        startActivity()
    }

    func playSoundIfNeeded() {
        guard let interval = busy.interval, !interval.isInfinite else {
            return
        }
        if settings.sound.intervals,
           interval.remaining >= .seconds(0),
           interval.remaining <= .seconds(3)
        {
            var name = interval.kind == .work ? "work" : "rest"
            name.append(
                interval.remaining == .seconds(0)
                    ? "_finished"
                    : "_countdown"
            )
            print(name)
            play(name)
        } else if settings.sound.metronome {
            play("tick")
        }
    }

    func play(_ name: String, onType type: String = "mp3") {
        guard let path = Bundle.main.path(
            forResource: name,
            ofType: type
        ) else {
            return
        }

        let url = URL(fileURLWithPath: path)

        do {
            player?.stop()
            player = try AVAudioPlayer(contentsOf: url)
            player?.play()
        } catch let error {
            print(error.localizedDescription)
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
