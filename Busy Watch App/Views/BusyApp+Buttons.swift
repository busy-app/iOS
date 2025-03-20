import SwiftUI

extension BusyApp {
    struct StartButton: View {
        var action: () -> Void

        var body: some View {
            Button {
                action()
            } label: {
                HStack(spacing: 10) {
                    Image(.playIcon)

                    Text("Start")
                        .font(.pragmaticaNextVF(size: 16))
                }
                .padding(.vertical, 15)
                .padding(.horizontal, 26)
                .foregroundStyle(.black)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 112))
            }
            .buttonStyle(.borderless)
        }
    }
}
