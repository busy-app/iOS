import SwiftUI

extension BusyWidgetLiveActivity {
    struct LargeTimerWithAction: View {
        let busy: BusyWidgetAttributes.ContentState

        var body: some View {
            HStack(alignment: .center) {
                switch busy.state {
                case .paused, .running:
                    Timer(busy: busy)
                        .font(.jetBrainsMonoRegular(size: 40))
                case .finished:
                    TimerDone(kind: busy.kind)
                }

                Spacer()

                Button(busy: busy)
            }
            .frame(height: 40)
        }
    }

    struct SmallTimerWithAction: View {
        let busy: BusyWidgetAttributes.ContentState

        var body: some View {
            switch busy.state {
            case .paused, .running:
                Timer(busy: busy)
                    .font(.jetBrainsMonoRegular(size: 11))
            case .finished:
                Text(busy.kind.title)
                    .font(.pragmaticaNextVF(size: 11))
                    .foregroundStyle(.blackInvert)
                    .offset(y: 1.2) // Fix variant font alignment
            }
        }
    }

    private struct Timer: View {
        let busy: BusyWidgetAttributes.ContentState

        var body: some View {
            Text("00:00")
                .hidden()
                .overlay(alignment: .leading) {
                    Group {
                        if busy.state == .paused {
                            Text(busy.time.idle)
                        } else {
                            Text(
                                timerInterval: busy.time,
                                showsHours: false
                            )
                        }
                    }
                    .contentTransition(.numericText())
                    .foregroundStyle(.blackInvert)
                }
        }
    }

    private struct TimerDone: View {
        let kind: IntervalKind

        var body: some View {
            VStack(alignment: .leading) {
                Text(kind.title)
                    .font(.pragmaticaNextVF(size: 20))
                    .foregroundStyle(.blackInvert)
                    .offset(y: 1.2) // Fix variant font alignment

                Spacer()

                Text(kind.description)
                    .font(.pragmaticaNextVF(size: 12))
                    .foregroundStyle(.blackInvert.opacity(0.5))
                    .offset(y: 1.2) // Fix variant font alignment
            }
        }
    }
}

fileprivate extension IntervalKind {
    var title: String {
        switch self {
        case .work: "BUSY done"
        case .rest, .longRest: "Rest is over"
        }
    }

    var description: String {
        switch self {
        case .work: "It’s time to have a rest"
        case .rest, .longRest: "Time to get back to work"
        }
    }
}

fileprivate extension ClosedRange<Date> {
    var idle: String {
        let seconds = Int(upperBound.timeIntervalSince(lowerBound))
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%d:%02d", minutes, remainingSeconds)
    }
}
