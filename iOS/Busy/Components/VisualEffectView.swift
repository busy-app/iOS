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

struct Blur: View {
    let style: UIBlurEffect.Style

    init(_ style: UIBlurEffect.Style) {
        self.style = style
    }

    var body: some View {
        VisualEffectView(effect: UIBlurEffect(style: style))
    }
}
