import SwiftUI

import ManagedSettings
import FamilyControls

struct BusyApp: View {
    @State var isOnToggle: Bool = false
    @AppStorage("isOn") var isOn: Bool = false

    @State var authorizationCenter = AuthorizationCenter.shared
    var isAuthorized: Bool {
        authorizationCenter.authorizationStatus == .approved
    }

    var managedSettingsStore: ManagedSettingsStore { .init() }

    @State var isChoosingApps: Bool = false
    @State var selection = FamilyActivitySelection()

    @AppStorage("applications")
    var applications: Set<ApplicationToken> = .init()

    @AppStorage("categories")
    var categories: Set<ActivityCategoryToken> = .init()

    @AppStorage("domains")
    var domains: Set<WebDomainToken> = .init()

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

            Button("Authorize") {
                authorize()
            }

            Button("Select Apps") {
                isChoosingApps = true
            }
            .familyActivityPicker(
                isPresented: $isChoosingApps,
                selection: $selection
            )
            .onChange(of: selection) { newSelection in
                self.applications = selection.applicationTokens
                self.categories = selection.categoryTokens
                self.domains = selection.webDomainTokens

                if isOn {
                    enableShield()
                }
            }
        }
        .padding(.horizontal, 24)
        .task {
            isOnToggle = isOn
            if !isAuthorized {
                authorize()
            }
        }
    }

    func authorize() {
        Task {
            do {
                try await authorizationCenter
                    .requestAuthorization(for: .individual)
            } catch {
                print(error)
            }
        }
    }

    func enableShield() {
        managedSettingsStore.shield.applications = applications
        managedSettingsStore.shield.applicationCategories =
            .specific(categories, except: [])
        managedSettingsStore.shield.webDomains = domains
        managedSettingsStore.shield.webDomainCategories =
            .specific(categories, except: [])
    }

    func disableShield() {
        managedSettingsStore.shield.applications = nil
        managedSettingsStore.shield.applicationCategories = nil
        managedSettingsStore.shield.webDomains = nil
        managedSettingsStore.shield.webDomainCategories = nil
    }
}
