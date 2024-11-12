import SwiftUI

struct NavBarButton<Label: View>: View {
    let action: () -> Void
    @ViewBuilder let label: () -> Label

    var body: some View {
        Button(action: action) {
            label()
        }
    }
}

struct NavBarBack: View {
    let action: () -> Void

    var body: some View {
        NavBarButton(action: action) {
            Image(.backNavIcon)
                .renderingMode(.template)
                .resizable()
                .frame(width: 32, height: 32)
                .foregroundColor(.blackInvert)
        }
    }
}

