import SwiftUI

extension EnvironmentValues {
    @Entry var appState: Binding<AppState> = .constant(.cards)
    @Entry var busyState: Binding<BusyState?> = .constant(nil)
    @Entry var settings: Binding<BusySettings?> = .constant(nil)
}

extension Binding where Value == BusyState {
    @MainActor
    var intervals: BusyState.Intervals {
        get { wrappedValue.intervals }
        nonmutating set { wrappedValue.intervals = newValue }
    }
}
