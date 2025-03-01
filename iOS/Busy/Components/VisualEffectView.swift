import SwiftUI

struct VisualEffectView: UIViewRepresentable {
    var effect: UIVisualEffect?
    func makeUIView(
        context: UIViewRepresentableContext<Self>
    ) -> UIVisualEffectView {
        .init()
    }
    func updateUIView(
        _ uiView: UIVisualEffectView,
        context: UIViewRepresentableContext<Self>
    ) {
        uiView.effect = effect
    }
}
