import SwiftUI

extension BusyView.TimerView {
    struct TimeCard: View {
        let interval: BusyState.Interval

        var progress: Double {
            interval.isInfinite ? 0 : interval.elapsed / interval.duration
        }

        var time: Duration {
            interval.isInfinite
                ? interval.elapsed
                : interval.duration - interval.elapsed
        }

        var body: some View {
            VStack(spacing: 0) {
                Time(time, countsDown: !interval.isInfinite)

                Progress(value: progress, kind: interval.kind)
                    .opacity(interval.isInfinite ? 0 : 1)
                    .padding(.top, 11.5)
            }
        }
    }

    struct Progress: View {
        let value: Double
        let kind: IntervalKind

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
                        .padding(.trailing, proxy.size.width * value)
                }
            }
            .frame(height: 6)
        }
    }

    struct Time: View {
        let duration: Duration
        let countsDown: Bool

        init(_ duration: Duration, countsDown: Bool) {
            self.duration = duration
            self.countsDown = countsDown
        }

        var minutes: Int {
            duration.seconds / 60
        }

        var seconds: Int {
            duration.seconds % 60
        }

        var body: some View {
            HStack(spacing: 4) {
                Spacer(minLength: 0)

                HStack {
                    Spacer()
                    Text(String(format: "%02d", minutes))
                }

                Text(":")
                    .frame(width: 25.5)

                HStack {
                    Text(String(format: "%02d", seconds))
                    Spacer()
                }

                Spacer(minLength: 0)
            }
            .font(.jetBrainsMonoRegular(size: 32))
            .foregroundStyle(.white)
            .animation(.linear, value: duration)
            .contentTransition(.numericText(countsDown: countsDown))
        }
    }
}

#Preview {
    VStack {
        BusyView.TimerView.TimeCard(
            interval: .init(
                kind: .work,
                duration: .seconds(15 * 60 + 05),
                elapsed: .seconds(15 * 60 + 05) * 0.8
            )
        )
        .colorScheme(.light)
        .padding(24)
    }
    .background(.gray)
}
