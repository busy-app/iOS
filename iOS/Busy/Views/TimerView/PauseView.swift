import SwiftUI

extension TimerView {
    struct PauseView: View {
        @Environment(\.appState) var appState

        var body: some View {
            VStack {
                Spacer()

                Image(.pauseIcon)
                    .resizable()
                    .frame(width: 66, height: 66)

                Spacer()

                StartButton {
                    switch appState.wrappedValue {
                    case .paused(let state): appState.wrappedValue = state
                    default: break
                    }
                }
                .padding(.bottom, 64)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.backgroundPause)
        }
    }
}

#Preview {
    TimerView.PauseView()
}
