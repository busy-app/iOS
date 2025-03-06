import SwiftUI

struct AutoHeightModifier: ViewModifier {
    @State private var height: Double = 0.0

    struct Key: PreferenceKey {
        static let defaultValue: Double = .zero

        static func reduce(value: inout Double, nextValue: () -> Double) {
            value = nextValue()
        }
    }

    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { proxy in
                    Color.clear.preference(
                        key: Key.self,
                        value: proxy.size.height
                    )
                }
            }
            .onPreferenceChange(Key.self) { height in
                Task { @MainActor in
                    self.height = height
                }
            }
            .presentationDetents([.height(height)])
    }
}

extension View {
    func presentationAutoHeight() -> some View {
        self.modifier(AutoHeightModifier())
    }
}
