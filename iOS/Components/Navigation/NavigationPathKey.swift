import SwiftUI

extension EnvironmentValues {
    @Entry var path: Binding<NavigationPath> = .constant(.init())
}

extension Binding where Value == NavigationPath {
    func append<V>(_ value: V) where V: Hashable {
        wrappedValue.append(value)
    }

    func dropLast() {
        guard !wrappedValue.isEmpty else { return }
        wrappedValue.removeLast()
    }

    func clear() {
        wrappedValue.removeLast(wrappedValue.count)
    }
}
