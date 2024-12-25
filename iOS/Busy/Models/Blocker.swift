import Observation

import ManagedSettings
import FamilyControls

@Observable
final class Blocker {
    static let shared = Blocker()

    @ObservationIgnored 
    private let managedSettingsStore: ManagedSettingsStore

    private(set) var settings: BlockerSettings {
        didSet {
            UserDefaultsStorage.shared.blockerSettings = settings
        }
    }

    private init() {
        managedSettingsStore = ManagedSettingsStore()
        settings = UserDefaultsStorage.shared.blockerSettings
    }

    func setStatus(_ value: Bool) {
        settings.isEnabled = value
    }

    func update(by selection: FamilyActivitySelection) {
        settings.applicationTokens = selection.applicationTokens
        settings.categoryTokens = selection.categoryTokens
        settings.domainTokens = selection.webDomainTokens
    }

    func enableShield() {
        guard settings.isEnabled else { return }

        managedSettingsStore.shield.applications =
        settings.applicationTokens
        managedSettingsStore.shield.applicationCategories =
            .specific(settings.categoryTokens, except: .init([]))

        managedSettingsStore.shield.webDomains =
        settings.domainTokens
        managedSettingsStore.shield.webDomainCategories =
            .specific(settings.categoryTokens, except: .init([]))
    }

    func disableShield() {
        managedSettingsStore.shield.applications = nil
        managedSettingsStore.shield.applicationCategories = nil

        managedSettingsStore.shield.webDomains = nil
        managedSettingsStore.shield.webDomainCategories = nil
    }
}
