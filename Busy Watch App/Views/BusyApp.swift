import SwiftUI

struct BusyApp: View {
    @AppStorage("settings")
    var settings: BusySettings = .init()

    @State var appState: AppState = .cards

    var body: some View {
        Group {
            switch appState {
            case .cards: CardsView(settings: $settings)
            case .busy: BusyView(settings: $settings)
            }
        }
        .environment(\.appState, $appState)
        .onReceive(Connectivity.shared.$settings) { settings in
            if let settings {
                self.settings = settings
            }
        }
    }
}
#Preview {
    BusyApp()
}
