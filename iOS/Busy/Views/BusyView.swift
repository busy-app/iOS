import SwiftUI

struct BusyView: View {
    @Binding var settings: BusySettings

    @State var state: BusyState = .init(.init())

    var body: some View {
        Group {
            if let interval = state.interval {
                TimerView(
                    interval: interval,
                    state: $state,
                    settings: $settings
                )
            } else {
                TimerView.FinishedView {
                    startBusy()
                }
            }
        }
        .task {
            startBusy()
        }
    }

    func startBusy() {
        state = .init(settings)
        state.start()
    }
}
