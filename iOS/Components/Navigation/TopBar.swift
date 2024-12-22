import SwiftUI

extension View {
    func topBar<Content>(
        @ToolbarContentBuilder toolbar: () -> Content
    ) -> some View where Content: ToolbarContent {
        self
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden(true)
            .toolbar(content: toolbar)
    }
}
