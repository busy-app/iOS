import SwiftUI

enum CodeFieldState: CaseIterable, Equatable {
    case `default`
    case invalid
    case expired
}

extension EnvironmentValues {
    @Entry var codeFieldState = CodeFieldState.default
}
