import SwiftUI

struct BusyApp: View {
    @State var settings: BusySettings = .init()

    @State var appState: AppState = .cards

    var body: some View {
        Group {
            switch appState {
            case .cards: CardsView(settings: $settings)
            case .busy: BusyView(settings: $settings)
            }
        }
        .environment(\.appState, $appState)
    }
}
#Preview {
    BusyApp()
}
