import SwiftUI

extension BusyView {
    typealias StartButton = BusyApp.StartButton
    typealias StopButton = BusyApp.StopButton
    typealias PauseButton = BusyApp.PauseButton
    typealias FinishButton = BusyApp.FinishButton
    typealias WhiteButton = BusyApp.WhiteButton
}

extension BusyApp {
    struct StartButton: View {
        var action: () -> Void

        var body: some View {
            WhiteButton(action: action) {
                HStack(spacing: 10) {
                    Image(.playIcon)

                    Text("Start")
                        .font(.pragmaticaNextVF(size: 16))
                }
            }
        }
    }

    struct StopButton: View {
        var action: () -> Void

        var body: some View {
            WhiteButton(action: action) {
                HStack(spacing: 10) {
                    Image(.stopIcon)

                    Text("Stop")
                        .font(.pragmaticaNextVF(size: 16))
                }
            }
        }
    }

    struct PauseButton: View {
        var action: () -> Void

        var body: some View {
            BlurButton(action: action) {
                HStack(spacing: 10) {
                    Image(.pauseIcon)

                    Text("Pause")
                        .font(.pragmaticaNextVF(size: 16))
                        .foregroundStyle(.white.opacity(0.5))
                }
            }
        }
    }

    struct FinishButton: View {
        var action: () -> Void

        var body: some View {
            BlurButton(action: action) {
                Text("Finish")
                    .font(.pragmaticaNextVF(size: 16))
                    .foregroundStyle(.white)
            }
        }
    }

    struct WhiteButton<Label: View>: View {
        var action: () -> Void
        let label: () -> Label

        var body: some View {
            Button(action: action) {
                HStack(spacing: 10) {
                    label()
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 26)
                .foregroundStyle(.black)
                .background(.white)
                .clipShape(RoundedRectangle(cornerRadius: 112))
            }
            .buttonStyle(.borderless)
        }
    }

    struct BlurButton<Label: View>: View {
        var action: () -> Void
        let label: () -> Label

        var body: some View {
            Button {
                action()
            } label: {
                HStack(spacing: 10) {
                    label()
                }
                .padding(.vertical, 12)
                .padding(.horizontal, 26)
                .foregroundStyle(.black)
                .background(.white.opacity(0.05))
                .clipShape(RoundedRectangle(cornerRadius: 112))
            }
            .buttonStyle(.borderless)
        }
    }
}

#Preview {
    VStack(spacing: 24) {
        BusyApp.StartButton {}

        BusyApp.StopButton {}

        BusyApp.PauseButton {}

        BusyApp.FinishButton {}
    }
    .frame(maxWidth: .infinity, maxHeight: .infinity)
    .colorScheme(.light)
    .background(.black)
}
