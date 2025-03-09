import SwiftUI

import ManagedSettings
import FamilyControls

import ActivityKit

struct BusyApp: View {
    private var notifications: Notifications { .shared }

    @AppStorage("busySettings")
    var busySettings: BusySettings = .init()

    indirect enum AppState {
        case cards
        case busy
    }

    @State var appState: AppState = .cards

    var body: some View {
        Group {
            switch appState {
            case .cards: CardsView(settings: $busySettings)
            case .busy: BusyView(settings: $busySettings)
            }
        }
        .environment(\.appState, $appState)
        .task {
            #if !targetEnvironment(simulator)
            notifications.authorize()
            #endif
            disableShieldOnTerminate()
        }
    }

    func disableShieldOnTerminate() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.willTerminateNotification,
            object: nil,
            queue: .main
        ) { _ in
            MainActor.assumeIsolated {
                BusyShield.disable()
            }
        }
    }
}

#Preview {
    BusyApp()
        .colorScheme(.light)
}
