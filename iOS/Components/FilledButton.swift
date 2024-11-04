import SwiftUI

struct FilledButton<Label: View>: View {
    let action: () -> Void
    @ViewBuilder let label: () -> Label

    @Environment(\.isEnabled) var isEnabled

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
            .background(isEnabled ? .brandPrimary : .neutralQuaternary)
            .cornerRadius(8)
        }
    }
}

extension FilledButton where Label == Text {
    init(_ text: String, action: @escaping @MainActor () -> Void) {
        self.action = action
        self.label = {
            Text(text)
        }
    }
}
