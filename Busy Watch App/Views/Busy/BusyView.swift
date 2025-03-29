import SwiftUI

struct BusyView: View {
    @Binding var settings: BusySettings

    @State private var busy: BusyState = .init(.init())

    @Environment(\.appState) var appState

    var body: some View {
        Group {
            if let interval = busy.interval {
                if busy.state != .finished {
                    TimerView(
                        interval: interval,
                        busy: $busy,
                        settings: $settings
                    )
                    ._statusBarHidden()
                } else {
                    if interval.kind == .work {
                        WorkDoneView(busy: $busy) {
                            busy.next()
                            busy.start()
                            sendState()
                        }
                    } else {
                        RestOverView {
                            busy.next()
                            busy.start()
                            sendState()
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
        .onChange(of: busy.interval?.remaining) {
            feedbackIfNeeded()
        }
        .task {
            startBusy()
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
        busy = .init(settings)
        busy.start()
        sendState()
    }

    func feedbackIfNeeded() {
        guard let interval = busy.interval else { return }

        if interval.remaining == .seconds(0) {
            WKInterfaceDevice.current().play(.success)
        }
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
}
