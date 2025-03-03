import SwiftUI

extension TimerView {
    struct TimeCard: View {
        let duration: Duration
        let progress: Double
        let kind: BusyState.Interval.Kind

        var video: String {
            switch kind {
            case .work: "Fire.mp4"
            case .rest, .longRest: "Smoke.mp4"
            }
        }

        var videoOpacity: Double {
            switch kind {
            case .work: 0.2
            case .rest, .longRest: 0.3
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
                    .opacity(0)
                }

                Time(duration: duration)

                Progress(value: progress, kind: kind)
            }
            .padding(24)
            .background {
                #if DISABLE_VIDEO
                switch kind {
                case .work: Color.red.opacity(0.8)
                case .rest: Color.green.opacity(0.8)
                case .longRest: Color.blue.opacity(0.8)
                }
                #else
                LoopingVideoPlayer(video)
                    .opacity(videoOpacity)
                    .disabled(true)
                    .scaledToFill()
                    .scaleEffect(1.3)
                #endif
            }
            .clipShape(RoundedRectangle(cornerRadius: 24))
        }
    }

    struct Progress: View {
        let value: Double
        let kind: BusyState.Interval.Kind

        var background: Color {
            foreground.opacity(0.1)
        }

        var foreground: Color {
            switch kind {
            case .work: .red
            case .rest: .green
            case .longRest: .green
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
        let duration: Duration

        var minutes: Int {
            duration.seconds / 60
        }

        var seconds: Int {
            duration.seconds % 60
        }

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
            .animation(.linear, value: duration)
            .contentTransition(.numericText(countsDown: false))
        }
    }
}

#Preview {
    VStack {
        TimerView.TimeCard(
            duration: .seconds(15 * 60 + 05),
            progress: 0.8,
            kind: .work
        )
        .colorScheme(.light)
        .padding(24)
    }
    .background(.gray)
}
