import SwiftUI

extension View {
    // NOTE: Not sure about this modifier, but it's used with NavigationStack
    func navAppearance() -> some View {
        self
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
    }

    func navAppearance<Content>(
        @ToolbarContentBuilder toolbar: () -> Content
    ) -> some View where Content: ToolbarContent {
        self
            .navAppearance()
            .toolbar(content: toolbar)
    }
}
