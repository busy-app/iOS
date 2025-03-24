import SwiftUI

extension BusyApp {
    struct CardsView: View {
        @Binding var settings: BusySettings

        @Environment(\.appState) var appState

        var body: some View {
            VStack(spacing: 0) {
                BusyCard(settings: $settings)

                StartButton {
                    appState.wrappedValue = .busy
                }
                .padding(.top, 100)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.backgroundCards)
        }
    }
}
