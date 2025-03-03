import SwiftUI
//import ManagedSettings
//
//extension EnvironmentValues {
//    @Entry var : Binding<BusySettings> = .constant(.init())
//}
//
//extension Binding where Value == BlockerSettings {
//    var isOn: Bool {
//        get { wrappedValue.isOn }
//        nonmutating set { wrappedValue.isEnabled = newValue }
//    }
//
//    var applicationTokens: Set<ApplicationToken> {
//        get { wrappedValue.applicationTokens }
//        nonmutating set { wrappedValue.applicationTokens = newValue }
//    }
//
//    var categoryTokens: Set<ActivityCategoryToken> {
//        get { wrappedValue.categoryTokens }
//        nonmutating set { wrappedValue.categoryTokens = newValue }
//    }
//
//    var domainTokens: Set<WebDomainToken> {
//        get { wrappedValue.domainTokens }
//        nonmutating set { wrappedValue.domainTokens = newValue }
//    }
//}


extension EnvironmentValues {
    @Entry var appState: Binding<BusyApp.AppState> = .constant(.cards)
}

extension EnvironmentValues {
    @Entry var busyState: Binding<BusyState?> = .constant(nil)
    @Entry var settings: Binding<BusySettings?> = .constant(nil)
}

extension Binding where Value == BusyState {
    @MainActor
    var intervals: BusyState.Intervals {
        get { wrappedValue.intervals }
        nonmutating set { wrappedValue.intervals = newValue }
    }

    @MainActor
    var timer: Busy.Timer {
        get { wrappedValue.timer }
        nonmutating set { wrappedValue.timer = newValue }
    }
}
