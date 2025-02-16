import SwiftUI

extension TimerView {
    struct StartButton: View {
        var action: () -> Void

        var body: some View {
            Button {
                action()
            } label: {
                HStack {
                    Image(.playIcon)
                        .renderingMode(.template)

                    Text("Start")
                        .font(.pragmaticaNextVF(size: 24))
                }
                .frame(width: 191, height: 64)
                .foregroundStyle(.blackInvert)
                .background(.whiteInvert)
                .clipShape(RoundedRectangle(cornerRadius: 112))
            }
        }
    }

    struct PauseButton: View {
        var action: () -> Void

        var body: some View {
            Button {
                action()
            } label: {
                HStack {
                    Image(.pauseIcon)
                        .renderingMode(.template)

                    Text("Pause")
                        .font(.pragmaticaNextVF(size: 24))
                }
                .frame(width: 191, height: 64)
                .foregroundStyle(.transparentWhiteInvertPrimary)
                .background(.transparentWhiteInvertQuinary)
                .clipShape(RoundedRectangle(cornerRadius: 112))
            }
        }
    }

    struct SkipButton: View {
        let action: () -> Void

        public var body: some View {
            Button {
                action()
            } label: {
                Text("Skip")
                    .font(.pragmaticaNextVF(size: 18))
                    .foregroundStyle(.transparentWhiteInvertSecondary)
            }
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
                        .font(.pragmaticaNextVF(size: 24))
                }
                .frame(width: 214, height: 64)
                .foregroundStyle(.whiteInvert)
                .background(.transparentWhiteInvertTertiary)
                .clipShape(RoundedRectangle(cornerRadius: 112))
            }
        }
    }

    struct RestartButton: View {
        var action: () -> Void

        var body: some View {
            Button {
                action()
            } label: {
                HStack {
                    Text("Restart BUSY")
                        .font(.pragmaticaNextVF(size: 18))
                }
                .frame(width: 214, height: 64)
                .foregroundStyle(.transparentWhiteInvertPrimary)
                .background(.clear)
                .clipShape(RoundedRectangle(cornerRadius: 112))
            }
        }
    }
}

#Preview {
    VStack {
        TimerView.StartButton {}

        TimerView.PauseButton {}

        TimerView.SkipButton {}

        TimerView.FinishButton {}

        TimerView.RestartButton {}
    }
    .colorScheme(.light)
}
