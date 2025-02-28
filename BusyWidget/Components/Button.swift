import ActivityKit
import SwiftUI

extension BusyWidgetLiveActivity {
    struct Button: View {
        let state: BusyWidgetAttributes.ContentState

        var buttonColor: Color {
            switch state.event {
            case .paused: .blackInvert
            case .active, .completed: .transparentWhiteQuaternary
            }
        }

        var contentColor: Color {
            switch state.event {
            case .paused: .whiteInvert
            case .active, .completed: .transparentWhitePrimary
            }
        }

        var buttonText: String {
            switch (state.event, state.tag) {
            case (.active, _): "Pause"
            case (.paused, _): "Start"
            case (.completed, .resting): "Start BUSY"
            case (.completed, .working): "Start rest"
            }
        }

        var icon: Image? {
            switch state.event {
            case .active: Image(.pause)
            case .paused: Image(.play)
            case .completed: nil
            }
        }

        var body: some View {
            SwiftUI.Button(intent: StopBusyIntent()) {
                HStack(alignment: .center, spacing: 8) {
                    if let icon {
                        icon
                            .renderingMode(.template)
                    }

                    Text(buttonText)
                        .font(.pragmaticaNextVF(size: 18))
                        .offset(y: 1.2) // Fix variant font alignment
                }
                .foregroundStyle(contentColor)
            }
            .buttonStyle(.plain)
            .padding(.vertical, 16)
            .padding(.horizontal, 32)
            .background(buttonColor)
            .cornerRadius(120)
        }
    }
}
