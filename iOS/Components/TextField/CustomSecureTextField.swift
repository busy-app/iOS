import SwiftUI

struct CustomSecureTextField: View {
    @State private var isPasswordVisible = false

    @Environment(\.textFieldState) var state

    @Binding var text: String
    let placeholder: String

    let caption: TextFieldCaption

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

    var body: some View {
        VStack(spacing: 4) {
            HStack(spacing: 12) {
                Image(.password)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 12, height: 12)
                    .foregroundColor(.neutralTertiary)
                    .padding(4)
                    .overlay {
                        RoundedRectangle(cornerRadius: 4)
                            .foregroundColor(.transparentBlackInvertQuaternary)
                    }

                Group {
                    if isPasswordVisible {
                        TextField(
                            "",
                            text: $text,
                            prompt: Text(placeholder)
                                .font(.labelPrimary)
                                .foregroundColor(.neutralTertiary)
                        )
                    }
                    else {
                        SecureField(
                            "",
                            text: $text,
                            prompt: Text(placeholder)
                                .font(.labelPrimary)
                                .foregroundColor(.neutralTertiary)
                        )
                    }
                }
                .accentColor(.neutralTertiary)
                .font(.labelPrimary)
                .foregroundColor(.blackInvert)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .keyboardType(UIKeyboardType.alphabet)

                Rectangle()
                    .foregroundColor(.neutralQuaternary)
                    .frame(maxWidth: .infinity)
                    .frame(width: 1, height: 24)

                switch state {
                case .loading:
                    AnimatedLoader(color: .neutralTertiary)
                        .frame(width: 16, height: 16)
                default:
                    Image(isPasswordVisible ? .passwordShow : .passwordHide)
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(.neutralTertiary)
                        .frame(width: 16, height: 16)
                        .onTapGesture { isPasswordVisible.toggle() }
                }

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
                        .foregroundColor(
                            state == .invalid
                                ? .dangerPrimary
                                : .neutralTertiary
                        )
                case .invalid(let text):
                    Text(text)
                        .foregroundColor(.dangerPrimary)
                        .opacity(state == .invalid ? 1 : 0)
                }
            }
            .font(.labelSecondary)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .opacity(state.isDisable ? 0.5 : 1)
        .disabled(state.isDisable)
    }
}

struct CustomSecureTextField_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(TextFieldState.allCases, id: \.self) { state in
                VStack(spacing: 16) {
                    CustomSecureTextField(
                        text: .constant(""),
                        placeholder: "Placeholder",
                        caption: .none
                    )

                    CustomSecureTextField(
                        text: .constant("user@sample.test"),
                        placeholder: "Placeholder",
                        caption: .always(
                            "At least 8 characters, including a number" +
                            " letter, a lowercase letter, and a special")
                    )

                    CustomSecureTextField(
                        text: .constant("user@sample.test"),
                        placeholder: "Placeholder",
                        caption: .invalid(
                            "At least 8 characters, including a number" +
                            " letter, a lowercase letter, and a special")
                    )
                }
                .padding()
                .environment(\.textFieldState, state)
                .previewDisplayName("Secure Text Field \(state)")
            }
        }
    }
}
