import SwiftUI

struct NavigationBackButton: ToolbarContent {
    @Environment(\.dismiss) var dismiss

    var body: some ToolbarContent {
        ToolbarItem(placement: .topBarLeading) {
            Button {
                dismiss()
            } label: {
                Image(.backNavIcon)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 32, height: 32)
                    .foregroundColor(.blackInvert)
            }
        }
    }
}
