import SwiftUI

struct StrokedButton<Label: View>: View {
    let action: () -> Void
    @ViewBuilder let label: () -> Label

    init(
        action: @escaping @MainActor () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.action = action
        self.label = label
    }

    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Spacer()
                label()
                    .font(.ppNeueMontrealRegular(size: 16))
                    .foregroundColor(.whiteOnContent)
                    .padding(.vertical, 14)
                Spacer()
            }
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.brandPrimary, lineWidth: 2)
            }
        }
    }
}

extension StrokedButton where Label == Text {
    init(_ text: String, action: @escaping @MainActor () -> Void) {
        self.action = action
        self.label = {
            Text(text)
        }
    }
}
