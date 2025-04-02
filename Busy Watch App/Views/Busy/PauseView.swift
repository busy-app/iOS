import SwiftUI

extension BusyView {
    struct PauseOverlayView: View {
        var action: () -> Void

        var body: some View {
            VStack(spacing: 0) {
                Spacer()
                    .frame(maxHeight: .infinity)

                Button {
                    action()
                } label: {
                    Image(.pauseIcon)
                        .resizable()
                        .frame(width: 56, height: 56)
                }
                .buttonStyle(.borderless)

                Spacer(minLength: 0)

                VStack(spacing: 0) {
                    Spacer()
                    StartButton {
                        action()
                    }
                }
                .frame(maxHeight: .infinity)
            }
            .padding(isAppleWatchLarge ? 20 : 12)
            .ignoresSafeArea(.all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.ultraThinMaterial)
        }
    }
}

#Preview {
    BusyView.PauseOverlayView {}
}
