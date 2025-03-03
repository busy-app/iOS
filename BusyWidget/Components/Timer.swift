import SwiftUI

extension BusyWidgetLiveActivity {
    struct LargeTimerWithAction: View {
        let state: BusyWidgetAttributes.ContentState

        var body: some View {
            HStack(alignment: .center) {
                switch state.event {
                case .active, .paused:
                    Timer(state: state, fontSize: 40)
                case .completed:
                    TimerDone(tag: state.tag)
                }

                Spacer()

                Button(state: state)
            }
            .frame(height: 40)
        }
    }

    struct SmallTimerWithAction: View {
        let state: BusyWidgetAttributes.ContentState

        var body: some View {
            switch state.event {
            case .active, .paused:
                Timer(state: state, fontSize: 11)
                    // FIXME: Timer display on full width when hours are not present
                    .multilineTextAlignment(.center)
            case .completed:
                Text(state.tag.title)
                    .font(.pragmaticaNextVF(size: 11))
                    .foregroundStyle(.blackInvert)
                    .offset(y: 1.2) // Fix variant font alignment
            }
        }
    }

    private struct Timer: View {
        let state: BusyWidgetAttributes.ContentState
        let fontSize: Double

        var body: some View {
            Text(timerInterval: .now...state.deadline)
                .contentTransition(.numericText())
                .font(.jetBrainsMonoRegular(size: fontSize))
                .foregroundStyle(.blackInvert)
        }
    }

    private struct TimerDone: View {
        let tag: BusyWidgetAttributes.ContentState.Tag

        var body: some View {
            VStack(alignment: .leading) {
                Text(tag.title)
                    .font(.pragmaticaNextVF(size: 20))
                    .foregroundStyle(.blackInvert)
                    .offset(y: 1.2) // Fix variant font alignment

                Spacer()

                Text(tag.description)
                    .font(.pragmaticaNextVF(size: 12))
                    .foregroundStyle(.blackInvert.opacity(0.5))
                    .offset(y: 1.2) // Fix variant font alignment
            }
        }
    }
}

fileprivate extension BusyWidgetAttributes.ContentState.Tag {
    var title: String {
        switch self {
        case .working(let current, let all): "BUSY \(current)/\(all) done"
        case .resting: "Rest is over"
        }
    }

    var description: String {
        switch self {
        case .working: "It’s time to have a rest"
        case .resting: "Time to get back to work"
        }
    }
}
