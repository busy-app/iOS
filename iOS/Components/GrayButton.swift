import SwiftUI

struct GrayButton<Label: View>: View {
    let action: () -> Void
    let label: () -> Label

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
                Spacer(minLength: 0)
                label()
                    .font(.ppNeueMontrealRegular(size: 18))
                    .foregroundColor(.blackInvert)
                    .padding(.horizontal, 8)
                Spacer(minLength: 0)
            }
            .frame(minHeight: 56)
            .background(.transparentBlackInvertQuaternary)
            .cornerRadius(8)
        }
    }
}

extension GrayButton where Label == Text {
    init(_ text: String, action: @escaping @MainActor () -> Void) {
        self.action = action
        self.label = {
            Text(text)
        }
    }
}
