import SwiftUI

struct LeadingToolbarItems<Content: View>: ToolbarContent {
    @ViewBuilder let content: () -> Content

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            content()
                .offset(x: -4)
        }
    }
}

struct PrincipalToolbarItems<Content: View>: ToolbarContent {
    @ViewBuilder let content: () -> Content

    var body: some ToolbarContent {
        ToolbarItem(placement: .principal) {
            content()
        }
    }
}

struct TrailingToolbarItems<Content: View>: ToolbarContent {
    @ViewBuilder let content: () -> Content

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
            content()
                .offset(x: 4)
        }
    }
}
