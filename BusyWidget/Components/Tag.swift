import SwiftUI

extension BusyWidgetLiveActivity {
    struct LargeTag: View {
        let busy: BusyWidgetAttributes.ContentState

        var body: some View {
            GeneralTag(busy: busy)
                .font(.pragmaticaNextVF(size: 18))
                .frame(width: 84)
        }
    }

    struct MediumTag: View {
        let state: BusyWidgetAttributes.ContentState

        var body: some View {
            GeneralTag(busy: state)
                .font(.pragmaticaNextVF(size: 11))
                .frame(width: 48)
        }
    }

    struct SmallTag: View {
        let state: BusyWidgetAttributes.ContentState

        var body: some View {
            GeneralTag(busy: state)
                .font(.pragmaticaNextVF(size: 11))
                .frame(width: 34)
        }
    }

    private struct GeneralTag: View {
        let busy: BusyWidgetAttributes.ContentState

        var text: String {
            switch busy.kind {
            case .work: "BUSY"
            case .rest, .longRest: "REST"
            }
        }

        var color: Color {
            switch busy.kind {
            case .work: .accentBrandPrimary
            case .rest, .longRest: .greenBrandPrimary
            }
        }

        var body: some View {
            Text(text)
                .foregroundStyle(.whiteOnContent)
                .offset(y: 1.2) // Fix variant font alignment
                .padding(.vertical, 8)
                .frame(maxWidth: .infinity)
                .background(color)
                .cornerRadius(120)
                .overlay {
                    IconEvent(state: busy.state)
                }
        }
    }

    private struct IconEvent: View {
        let state: TimerState

        var icon: Image? {
            switch state {
            case .running: nil
            case .finished: Image(.complete)
            case .paused: Image(.pause)
            }
        }

        var body: some View {
            if let icon {
                ZStack {
                    Color.black.opacity(0.7)
                        .cornerRadius(120)

                    icon
                        .renderingMode(.template)
                        .foregroundStyle(.whiteOnContent)
                        .padding(4)
                        .scaledToFit()
                }
            }
        }
    }
}
