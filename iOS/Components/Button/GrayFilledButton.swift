import SwiftUI

// NOTE: Better naming
struct GrayFilledButton<Label: View>: View {
    @Environment(\.buttonState) var state

    let action: () -> Void
    let icon: ImageResource
    @ViewBuilder let label: () -> Label

    init(
        icon: ImageResource,
        action: @escaping @MainActor () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.icon = icon
        self.action = action
        self.label = label
    }

    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 8) {
                Image(icon)
                    .resizable()
                    .frame(width: 24, height: 24)

                label()
                    .lineLimit(1)
                    .font(.labelPrimary)
                    .foregroundColor(.blackInvert)
                    .frame(maxWidth: .infinity)

                if state == .loading {
                    AnimatedLoader(color: .transparentBlackInvertSecondary)
                        .frame(width: 16, height: 16)
                }
            }
            .frame(height: 44)
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
            .background(.transparentBlackInvertQuaternary)
            .cornerRadius(8)
        }
        .opacity(state.isDisable ? 0.5 : 1)
        .disabled(state.isDisable)
    }
}

extension GrayFilledButton where Label == Text {
    init(
        icon: ImageResource,
        _ text: String,
        action: @escaping @MainActor () -> Void
    ) {
        self.action = action
        self.icon = icon
        self.label = { Text(text) }
    }
}

extension GrayFilledButton where Label == EmptyView {
    init(
        icon: ImageResource,
        action: @escaping @MainActor () -> Void
    ) {
        self.action = action
        self.icon = icon
        self.label = {  EmptyView() }
    }
}

struct GrayFilledButton_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(ButtonState.allCases, id: \.self) { state in
                VStack {
                    GrayFilledButton(
                        icon: .googleLogo,
                        "Continue with Google"
                    ) {}

                    GrayFilledButton(
                        icon: .googleLogo,
                        "Continue with Google"
                    ) {}
                        .frame(width: 300)

                    GrayFilledButton(
                        icon: .appleLogo
                    ) {}

                    HStack {
                        GrayFilledButton(icon: .appleLogo) {}
                        GrayFilledButton(icon: .googleLogo) {}
                        GrayFilledButton(icon: .microsoftLogo) {}
                    }
                }
                .padding()
                .environment(\.buttonState, state)
                .previewDisplayName("Button \(state)")
            }
        }
    }
}
