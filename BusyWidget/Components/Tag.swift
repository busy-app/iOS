import SwiftUI

extension BusyWidgetLiveActivity {
    struct LargeTag: View {
        let busy: BusyWidgetAttributes.ContentState

        var body: some View {
            GeneralTag(
                busy: busy,
                fontSize: 18,
                insets: EdgeInsets(
                    top: 8,
                    leading: 12,
                    bottom: 8,
                    trailing: 12
                )
            )
        }
    }

    struct MediumTag: View {
        let state: BusyWidgetAttributes.ContentState

        var body: some View {
            GeneralTag(
                busy: state,
                fontSize: 11,
                insets: EdgeInsets(
                    top: 8,
                    leading: 8,
                    bottom: 8,
                    trailing: 8
                )
            )
        }
    }

    struct SmallTag: View {
        let state: BusyWidgetAttributes.ContentState

        var body: some View {
            GeneralTag(
                busy: state,
                fontSize: 11,
                insets: EdgeInsets(
                    top: 8,
                    leading: 2,
                    bottom: 8,
                    trailing: 2
                )
            )
        }
    }

    private struct GeneralTag: View {
        let busy: BusyWidgetAttributes.ContentState
        let fontSize: Double
        let insets: EdgeInsets

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
                .font(.pragmaticaNextVF(size: fontSize))
                .foregroundStyle(.whiteOnContent)
                .offset(y: 1.2) // Fix variant font alignment
                .padding(insets)
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
