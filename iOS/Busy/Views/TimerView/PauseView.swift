import SwiftUI

extension TimerView {
    struct PauseOverlayView: View {
        @Environment(\.appState) var appState

        var body: some View {
            VStack {
                Spacer()

                Button {
                    switch appState.wrappedValue {
                    case .paused(let state): appState.wrappedValue = state
                    default: break
                    }
                } label: {
                    Image(.pauseIcon)
                        .resizable()
                        .frame(width: 66, height: 66)
                }

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
            .background(.black.opacity(0.8))
        }
    }
}
 
#Preview {
    TimerView.PauseOverlayView()
}
