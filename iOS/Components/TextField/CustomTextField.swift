import SwiftUI

struct CustomTextField: View {
    @Environment(\.textFieldState) var state

    @Binding var text: String
    let placeholder: String

    let icon: ImageResource

    let caption: TextFieldCaption

    let type: UIKeyboardType

    private var borderColor: Color {
        switch state {
        case .invalid: .dangerSecondary
        default: .neutralQuaternary
        }
    }

    private var backgroundColor: Color {
        switch state {
        case .invalid: .dangerTertiary
        default: .neutralSeptenary
        }
    }

    private var opacity: Double {
        switch state {
        case .default, .invalid: 1
        case .disabled, .loading: 0.5
        }
    }

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 12) {
                Image(icon)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 12, height: 12)
                    .foregroundColor( .neutralTertiary)
                    .padding(4)
                    .overlay {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundColor(.transparentBlackInvertQuaternary)
                    }

                TextField(
                    "",
                    text: $text,
                    prompt: Text(placeholder)
                        .font(.labelPrimary)
                        .foregroundColor(.neutralTertiary)
                )
                .accentColor(.neutralTertiary)
                .font(.labelPrimary)
                .foregroundColor(.blackInvert)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .keyboardType(type)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 12)
            .background(backgroundColor)
            .cornerRadius(8)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(borderColor)
            }


            Group {
                switch caption {
                case .none:
                    EmptyView()
                case .always(let text):
                    Text(text)
                        .foregroundColor(.neutralTertiary)
                case .invalid(let text):
                    Text(text)
                        .foregroundColor(.dangerPrimary)
                        .opacity(state == .invalid ? 1 : 0)
                }
            }
            .font(.labelPrimary)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .opacity(state.isDisable ? 0.5 : 1)
        .disabled(state.isDisable)
    }
}

struct CustomTextField_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(TextFieldState.allCases, id: \.self) { state in
                VStack(spacing: 16) {
                    CustomTextField(
                        text: .constant(""),
                        placeholder: "Placeholder",
                        icon: .avatar,
                        caption: .none,
                        type: UIKeyboardType.emailAddress
                    )

                    CustomTextField(
                        text: .constant("user@sample.test"),
                        placeholder: "Placeholder",
                        icon: .avatar,
                        caption: .always(
                            "At least 8 characters, including a number" +
                            " letter, a lowercase letter, and a special"),
                        type: UIKeyboardType.emailAddress
                    )

                    CustomTextField(
                        text: .constant("user@sample.test"),
                        placeholder: "Placeholder",
                        icon: .avatar,
                        caption: .invalid(
                            "At least 8 characters, including a number" +
                            " letter, a lowercase letter, and a special"),
                        type: UIKeyboardType.emailAddress
                    )
                }
                .padding()
                .environment(\.textFieldState, state)
                .previewDisplayName("Text Field \(state)")
            }
        }
    }
}
