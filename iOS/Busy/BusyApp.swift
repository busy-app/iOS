import SwiftUI

import ManagedSettings
import FamilyControls

struct BusyApp: View {
    var authorizationCenter: AuthorizationCenter { .shared }
    var managedSettingsStore: ManagedSettingsStore { .init() }

    var isAuthorized: Bool {
        authorizationCenter.authorizationStatus == .approved
    }

    @State var isOnToggle: Bool = false
    @AppStorage("isOn") var isOn: Bool = false

    var body: some View {
        VStack(spacing: 40) {
            Toggle(isOn: $isOnToggle) {
                Text("Turn \(isOnToggle ? "off" : "on")")
            }
            .onChange(of: isOnToggle) { newValue in
                guard newValue != isOn else { return }

                print("Turining \(newValue ? "on" : "off")")

                guard isAuthorized else {
                    isOnToggle = isOn
                    authorize()
                    return
                }

                isOn = newValue
                isOn ? enableShield() : disableShield()
            }
        }
        .padding(.horizontal, 24)
        .task {
            isOnToggle = isOn
            if !isAuthorized {
                authorize()
            }
            if isOn {
                enableShield()
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

    func enableShield() {
        managedSettingsStore.shield.applicationCategories = .all(except: [])
        managedSettingsStore.shield.webDomainCategories = .all(except: [])
    }

    func disableShield() {
        managedSettingsStore.shield.applications = nil
        managedSettingsStore.shield.applicationCategories = nil
        managedSettingsStore.shield.webDomains = nil
        managedSettingsStore.shield.webDomainCategories = nil
    }
}
