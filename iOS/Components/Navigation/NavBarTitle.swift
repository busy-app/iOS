import SwiftUI

struct NavBarTitle: View {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some View {
        Text(text)
            .font(.titlePrimary)
            .foregroundColor(.blackInvert)
    }
}
