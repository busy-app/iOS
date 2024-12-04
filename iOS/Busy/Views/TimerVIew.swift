import SwiftUI

struct TimerView: View {
    @Binding var timer: Timer
    var action: () -> Void

    var body: some View {
        VStack {
            ActiveTimer(timer: $timer)
                .padding(.top, 90)

            StopButton {
                action()
            }
            .padding(.top, 16)
            .padding(.horizontal, 16)
            .padding(.bottom, 128)
        }
        .background(.backgroundBusy)
        .clipShape(
            .rect(
                topLeadingRadius: 16,
                bottomLeadingRadius: 0,
                bottomTrailingRadius: 0,
                topTrailingRadius: 16
            )
        )
    }
}
