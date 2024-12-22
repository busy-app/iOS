import SwiftUI

enum ButtonState: CaseIterable, Equatable {
    case `default`
    case disabled
    case loading

    var isDisable: Bool {
        self == .disabled || self == .loading
    }
}

extension EnvironmentValues {
    @Entry var buttonState = ButtonState.default
}
