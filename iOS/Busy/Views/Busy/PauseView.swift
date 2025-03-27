import SwiftUI

extension BusyView {
    struct PauseOverlayView: View {
        var action: () -> Void

        var body: some View {
            VStack {
                Spacer()

                Button {
                    action()
                } label: {
                    Image(.pauseIcon)
                        .resizable()
                        .frame(width: 66, height: 66)
                }

                Spacer()

                StartButton {
                    action()
                }
                .padding(.bottom, 64)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                Blur(.dark).ignoresSafeArea(.all)
            )
        }
    }
}
 
#Preview {
    BusyView.PauseOverlayView {}
}
