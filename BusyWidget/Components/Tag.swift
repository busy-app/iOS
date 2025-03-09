import SwiftUI

extension BusyWidgetLiveActivity {
    struct LargeTag: View {
        let state: BusyWidgetAttributes.ContentState

        var body: some View {
            GeneralTag(
                state: state,
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
                state: state,
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
                state: state,
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
        let state: BusyWidgetAttributes.ContentState
        let fontSize: Double
        let insets: EdgeInsets

        var text: String {
            switch state.tag {
            case .working:
                return "BUSY"
            case .resting:
                return "REST"
            }
        }

        var color: Color {
            switch state.tag {
            case .working:
                return .accentBrandPrimary
            case .resting:
                return .greenBrandPrimary
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
                    IconEvent(event: state.event)
                }
        }
    }

    private struct IconEvent: View {
        let event: BusyWidgetAttributes.ContentState.Event

        var icon: Image? {
            switch event {
            case .active: nil
            case .completed: Image(.complete)
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
