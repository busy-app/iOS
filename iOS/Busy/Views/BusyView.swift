import SwiftUI

struct BusyView: View {
    @Binding var settings: BusySettings

    @State var state: BusyState = .init(.init())

    var body: some View {
        Group {
            if let interval = state.interval {
                if state.timer.state != .finished {
                    TimerView(
                        interval: interval,
                        state: $state,
                        settings: $settings
                    )
                } else {
                    if interval.kind == .work {
                        TimerView.WorkDoneView {
                            state.next()
                            state.start()
                        }
                    } else {
                        TimerView.RestOverView {
                            state.next()
                            state.start()
                        }
                    }
                }
            } else {
                TimerView.FinishedView {
                    startBusy()
                }
            }
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
        state = .init(settings)
        state.start()
    }
}
