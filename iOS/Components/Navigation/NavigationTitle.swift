import SwiftUI

struct NavigationTitle: ToolbarContent {
    let text: String

    init(_ text: String) {
        self.text = text
    }

    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            Text(text)
                .font(.titlePrimary)
                .foregroundColor(.blackInvert)
        }
    }
}
