import SwiftUI

struct BusyView: View {
    @Binding var settings: BusySettings

    @State private var busy: BusyState = .init(.init())

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
    }

    func startBusy() {
        busy = .init(settings)
        busy.start()
    }

    func feedback() {
        WKInterfaceDevice.current().play(.success)
    }
}
