import SwiftUI

enum TextFieldState: CaseIterable, Equatable {
    case `default`
    case invalid
    case disabled
    case loading

    var isDisable: Bool {
        self == .disabled || self == .loading
    }
}

extension EnvironmentValues {
    @Entry var textFieldState = TextFieldState.default
}
