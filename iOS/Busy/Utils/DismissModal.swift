import SwiftUI

@MainActor struct DismissModalAction {
    @Binding var isPresented: Bool

    @MainActor func callAsFunction() {
        isPresented = false
    }
}

extension EnvironmentValues {
    @Entry
    var dismissModal: DismissModalAction = .init(isPresented: .constant(false))
}

extension View {
    func dismissModal(_ isPresented: Binding<Bool>) -> some View {
        self.environment(
            \.dismissModal,
             DismissModalAction(isPresented: isPresented)
        )
    }
}
