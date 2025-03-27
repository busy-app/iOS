import SwiftUI

extension BusyView {
    struct PauseOverlayView: View {
        var action: () -> Void

        var body: some View {
            VStack {
                StartButton {
                    action()
                }
                .padding(.top, 12)
                .opacity(0)

                Spacer()

                Button {
                    action()
                } label: {
                    Image(.pauseIcon)
                        .resizable()
                        .frame(width: 64, height: 64)
                }
                .buttonStyle(.borderless)

                Spacer()

                StartButton {
                    action()
                }
                .padding(.bottom, 12)
            }
            .ignoresSafeArea(.all)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.ultraThinMaterial)
        }
    }
}

#Preview {
    BusyView.PauseOverlayView {}
}
