import SwiftUI

extension BusyView {
    typealias StartButton = BusyApp.StartButton
    typealias FinishButton = BusyApp.FinishButton
    typealias RestartButton = BusyApp.RestartButton
}

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

    struct FinishButton: View {
        var action: () -> Void

        var body: some View {
            Button {
                action()
            } label: {
                HStack {
                    Text("Finish")
                        .font(.pragmaticaNextVF(size: 16))
                }
                .frame(width: 96, height: 46)
                .foregroundStyle(.white)
                .background(.white.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 112))
            }
            .buttonStyle(.borderless)
        }
    }

    struct RestartButton: View {
        var action: () -> Void

        var body: some View {
            Button {
                action()
            } label: {
                Image(.navRepeatIcon)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 9)
                    .background(.white.opacity(0.1))
                    .clipShape(Circle())
            }
            .buttonStyle(.borderless)
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        BusyApp.StartButton {}

        BusyApp.FinishButton {}

        BusyApp.RestartButton {}
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .colorScheme(.light)
    .background(.black)
}
