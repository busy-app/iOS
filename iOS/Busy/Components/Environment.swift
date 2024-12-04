import SwiftUI
import ManagedSettings

extension EnvironmentValues {
    @Entry var blockerSettings: Binding<BlockerSettings> = .constant(.init())
}

extension Binding where Value == BlockerSettings {
    var isEnabled: Bool {
        get { wrappedValue.isEnabled }
        nonmutating set { wrappedValue.isEnabled = newValue }
    }

    var applicationTokens: Set<ApplicationToken> {
        get { wrappedValue.applicationTokens }
        nonmutating set { wrappedValue.applicationTokens = newValue }
    }

    var categoryTokens: Set<ActivityCategoryToken> {
        get { wrappedValue.categoryTokens }
        nonmutating set { wrappedValue.categoryTokens = newValue }
    }

    var domainTokens: Set<WebDomainToken> {
        get { wrappedValue.domainTokens }
        nonmutating set { wrappedValue.domainTokens = newValue }
    }
}
