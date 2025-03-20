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
                .padding(.top, 5)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            // TODO: 1E1E1E
            .background(.black)
        }
    }
}

#Preview {
    @Previewable @State var settings: BusySettings = .init()

    BusyApp.CardsView(settings: $settings)
        .colorScheme(.light)
}
