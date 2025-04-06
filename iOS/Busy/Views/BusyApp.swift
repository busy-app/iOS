import SwiftUI

import ManagedSettings
import FamilyControls

import ActivityKit

struct BusyApp: View {
    private var notifications: Notifications { .shared }

    @AppStorage("busySettings")
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
        .task {
            #if !targetEnvironment(simulator)
            notifications.authorize()
            #endif
        }
        .onReceive(Connectivity.shared.$appState) { appState in
            if let appState {
                self.appState = appState
            }
        }
    }

    func sendState() {
        Connectivity.shared.send(
            settings: settings,
            appState: appState,
            busyState: nil
        )
    }
}

#Preview {
    BusyApp()
        .colorScheme(.light)
}
