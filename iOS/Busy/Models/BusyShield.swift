import Foundation

import ManagedSettings

class BusyShield {
    private static var managedSettingsStore: ManagedSettingsStore { .init() }

    static func enable(_ settings: BlockerSettings) {
        managedSettingsStore.shield.applications =
            settings.applicationTokens
        managedSettingsStore.shield.applicationCategories =
            .specific(settings.categoryTokens, except: .init([]))

        managedSettingsStore.shield.webDomains =
            settings.domainTokens
        managedSettingsStore.shield.webDomainCategories =
            .specific(settings.categoryTokens, except: .init([]))
    }

    static func disable() {
        managedSettingsStore.shield.applications = nil
        managedSettingsStore.shield.applicationCategories = nil

        managedSettingsStore.shield.webDomains = nil
        managedSettingsStore.shield.webDomainCategories = nil
    }
}
