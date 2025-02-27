import SwiftUI

extension TimerView {
    struct TimeCard: View {
        let state: TimerState

        @Environment(\.appState) var appState

        var video: String {
            switch appState.wrappedValue {
            case .working: "Fire.mp4"
            default: "Smoke.mp4"
            }
        }

        var videoOpacity: Double {
            switch appState.wrappedValue {
            case .working: 0.2
            default: 0.3
            }
        }

        var body: some View {
            VStack(spacing: 47) {
                HStack {
                    Spacer()
                    Button {
                        // TODO: open settings
                    } label: {
                        Text("Edit")
                            .font(.pragmaticaNextVF(size: 18))
                            .foregroundStyle(.transparentWhiteInvertSecondary)
                    }
                }

                Time(
                    minutes: state.minutes,
                    seconds: state.seconds
                )

                Progress(value: 0.85)
            }
            .padding(24)
            .background {
                LoopingVideoPlayer(video)
                    .opacity(videoOpacity)
                    .disabled(true)
                    .scaledToFill()
                    .scaleEffect(1.25)
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))
        }
    }

    struct Progress: View {
        let value: Double

        @Environment(\.appState) var appState

        var background: Color {
            foreground.opacity(0.1)
        }

        var foreground: Color {
            switch appState.wrappedValue {
            case .working: .red
            case .resting: .green
            case .longResting: .green
            default: .clear
            }
        }

        var body: some View {
            ZStack {
                background
                GeometryReader { proxy in
                    foreground
                        .padding(.trailing, proxy.size.width * (1 - value))
                }
            }
            .frame(height: 6)
        }
    }

    struct Time: View {
        let minutes: Int
        let seconds: Int

        var body: some View {
            HStack(spacing: 8) {
                Spacer(minLength: 0)

                HStack {
                    Spacer()
                    Text(String(format: "%02d", minutes))
                }

                Text(":")
                    .frame(width: 51)

                HStack {
                    Text(String(format: "%02d", seconds))
                    Spacer()
                }

                Spacer(minLength: 0)
            }
            .font(.jetBrainsMonoRegular(size: 64))
            .foregroundStyle(.surfacePrimary)
            .animation(.linear, value: minutes)
            .animation(.linear, value: seconds)
            .contentTransition(.numericText())
        }
    }
}

#Preview {
    VStack {
        TimerView.TimeCard(
            state: .init(
                minutes: 24,
                seconds: 04
            )
        )
        .environment(\.appState, .constant(.working))
        .colorScheme(.light)
        .padding(24)
    }
    .background(.gray)
}

