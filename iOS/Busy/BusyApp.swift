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
            disableActivitiesOnTerminate()
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

    func disableActivitiesOnTerminate() {
        NotificationCenter.default.addObserver(
            forName: UIApplication.willTerminateNotification,
            object: nil,
            queue: .main
        ) { _ in
            Task {
                for activity in Activity<BusyWidgetAttributes>.activities {
                    await activity.end(.none, dismissalPolicy: .immediate)
                }
            }
        }
    }
}

#Preview {
    BusyApp()
        .colorScheme(.light)
}
