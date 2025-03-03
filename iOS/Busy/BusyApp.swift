import SwiftUI

import ManagedSettings
import FamilyControls

import ActivityKit

struct BusyApp: View {
    private var authorizationCenter: AuthorizationCenter { .shared }
    private var managedSettingsStore: ManagedSettingsStore { .init() }
    private var notifications: Notifications { .shared }

    var isAuthorized: Bool {
        authorizationCenter.authorizationStatus == .approved
    }

    @AppStorage("busySettings")
    var busySettings: BusySettings = .init()

    @State private var activity: Activity<BusyWidgetAttributes>?

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
            if !isAuthorized {
                authorize()
            }
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
                disableShield()
            }
        }
    }

    func authorize() {
        Task {
            do {
                try await AuthorizationCenter
                    .shared
                    .requestAuthorization(for: .individual)
            } catch {
                print("authorization error: \(error)")
            }
        }
    }

    func startBusy() {
        #if !targetEnvironment(simulator)
        if busySettings.blocker.isOn {
            guard isAuthorized else {
                authorize()
                return
            }
            enableShield()
        }
        #endif
    }

    func enableShield() {
        managedSettingsStore.shield.applications =
            busySettings.blocker.applicationTokens
        managedSettingsStore.shield.applicationCategories =
            .specific(busySettings.blocker.categoryTokens, except: .init([]))

        managedSettingsStore.shield.webDomains =
            busySettings.blocker.domainTokens
        managedSettingsStore.shield.webDomainCategories =
            .specific(busySettings.blocker.categoryTokens, except: .init([]))
    }

    func disableShield() {
        managedSettingsStore.shield.applications = nil
        managedSettingsStore.shield.applicationCategories = nil

        managedSettingsStore.shield.webDomains = nil
        managedSettingsStore.shield.webDomainCategories = nil
    }
}

#Preview {
    BusyApp()
        .colorScheme(.light)
}
