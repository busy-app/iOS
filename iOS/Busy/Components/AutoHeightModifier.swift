import SwiftUI

struct AutoHeightModifier: ViewModifier {
    @State private var height: Double = 0.0

    // Fix presentationDetents height issue
    private var detents: Set<PresentationDetent> {
        height == 0
            ? [.medium]
            : [.height(height)]
    }

    func body(content: Content) -> some View {
        content
            .overlay {
                GeometryReader { proxy in
                    Color.clear.task {
                        self.height = proxy.size.height
                    }
                }
            }
            .presentationDetents(detents)
    }
}

extension View {
    func presentationAutoHeight() -> some View {
        self.modifier(AutoHeightModifier())
    }
}
