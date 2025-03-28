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
        .onChange(of: busy.state) {
            if busy.state == .finished {
                feedback()
            }
        }
        .onChange(of: busy.interval) { old, new in
            guard let old, let new else { return }
            if old.kind != new.kind {
                feedback()
            }
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

    func feedback() {
        WKInterfaceDevice.current().play(.success)
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
