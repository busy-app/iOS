import SwiftUI

import ActivityKit

struct BusyView: View {
    @Binding var settings: BusySettings

    @State private var busy: BusyState = .init(.init())

    @State private var activity: Activity<BusyWidgetAttributes>?

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
                        TimerView.WorkDoneView {
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
            onStateChange()
        }
        .task {
            startBusy()
        }
        .onDisappear {
            BusyShield.disable()
        }
    }

    func startBusy() {
        if settings.blocker.isOn {
            BusyShield.enable(settings.blocker)
        }
        busy = .init(settings)
        busy.start()
    }

    func onStateChange() {
        switch busy.state {
        case .running: startActivity()
        case .paused: stopActivity() //updateActivity()
        case .finished: stopActivity()
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
