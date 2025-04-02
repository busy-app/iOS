import SwiftUI

extension BusyApp {
    struct CardsView: View {
        @Binding var settings: BusySettings

        @Environment(\.appState) var appState

        var body: some View {
            VStack(spacing: 0) {
                Spacer()
                    .frame(maxHeight: .infinity)

                BusyCard(settings: $settings)

                VStack(spacing: 0) {
                    Spacer()
                    StartButton {
                        appState.wrappedValue = .busy
                    }
                }
                .frame(maxHeight: .infinity)
            }
            .padding(.vertical, isAppleWatchLarge ? 20 : 12)
            .edgesIgnoringSafeArea(.all)
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
