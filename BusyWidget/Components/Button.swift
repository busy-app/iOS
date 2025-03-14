import ActivityKit
import AppIntents
import SwiftUI

extension BusyWidgetLiveActivity {
    struct Button: View {
        let busy: BusyWidgetAttributes.ContentState

        var buttonColor: Color {
            switch busy.state {
            case .paused: .blackInvert
            case .running, .finished: .transparentWhiteQuaternary
            }
        }

        var contentColor: Color {
            switch busy.state {
            case .paused: .whiteInvert
            case .running, .finished: .transparentWhitePrimary
            }
        }

        var buttonText: String {
            switch (busy.state, busy.kind) {
            case (.running, _): "Pause"
            case (.paused, _): "Start"
            case (.finished, .rest): "Start BUSY"
            case (.finished, .longRest): "Start BUSY"
            case (.finished, .work): "Start rest"
            }
        }

        var icon: Image? {
            switch busy.state {
            case .paused: Image(.play)
            case .running: Image(.pause)
            case .finished: nil
            }
        }

        var intent: any AppIntent {
            switch busy.state {
            case .paused: StartBusyIntent()
            case .running: PauseBusyIntent()
            case .finished: NextBusyIntent()
            }
        }

        var body: some View {
            SwiftUI.Button(intent: intent) {
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
