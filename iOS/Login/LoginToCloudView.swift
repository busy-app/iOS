import SwiftUI

extension LoginFlow {
    struct LoginToCloudView: View {
        @State private var email = ""

        var body: some View {
            VStack(spacing: 0) {
                Text("Log in to Busy Cloud")
                    .font(.titlePrimary)
                    .foregroundColor(.blackInvert)

                Image(.busyCloud)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 160)
                    .padding(.top, 32)

                Text("Enter your email to log in or create an account:")
                    .font(.bodyPrimary)
                    .foregroundColor(.blackInvert)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 16)

                CustomTextField(
                    text: $email,
                    placeholder: "Email",
                    icon: .avatar,
                    caption: .none,
                    type: UIKeyboardType.emailAddress
                )
                .padding(.top, 16)

                FilledButton("Continue with email", action: {})
                    .padding(.top, 32)

                HStack {
                    Rectangle()
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.neutralQuinary)

                    Text("Or")
                        .padding(.horizontal, 8)
                        .foregroundColor(.neutralTertiary)

                    Rectangle()
                        .frame(height: 1)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.neutralQuinary)
                }
                .padding(.top, 32)

                HStack {
                    GrayFilledButton(icon: .googleLogo) {}
                    GrayFilledButton(icon: .appleLogo) {}
                    GrayFilledButton(icon: .microsoftLogo) {}
                }
                .padding(.top, 32)

                Spacer()

                ToSAndPrivacyPolicy()
                    .padding(.bottom, 8)
            }
            .padding(16)
            .background(.surfacePrimary)
        }
    }
}

extension LoginFlow.LoginToCloudView {
    struct ToSAndPrivacyPolicy: View {
        var byContinue: AttributedString {
            var result = AttributedString("By proceeding, you agree to our\n")
            result.foregroundColor = .neutralTertiary
            return result
        }

        var tos: AttributedString {
            var result = AttributedString("Terms of Service")
            result.foregroundColor = .bluetoothPrimary
            // TODO: result.link = URL(string: "")
            result.underlineStyle = Text.LineStyle(
                pattern: .solid,
                color: .bluetoothPrimary
            )
            return result
        }

        var and: AttributedString {
            var result = AttributedString(" and ")
            result.foregroundColor = .neutralTertiary
            return result
        }

        var privacyPolicy: AttributedString {
            var result = AttributedString("Privacy Policy")
            result.foregroundColor = .bluetoothPrimary
            // TODO: result.link = URL(string: "")
            result.underlineStyle = Text.LineStyle(
                pattern: .solid,
                color: .bluetoothPrimary
            )
            return result
        }

        var body: some View {
            Text(byContinue + tos + and + privacyPolicy)
                .multilineTextAlignment(.center)
                .font(.labelSecondary)
                .lineSpacing(4)
        }
    }
}

struct LoginToCloudView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(TextFieldState.allCases, id: \.self) { textFieldState in
                ForEach(ButtonState.allCases, id: \.self) { buttonState in
                    NavigationStack {
                        LoginFlow.LoginToCloudView()
                    }
                    .environment(\.buttonState, buttonState)
                    .environment(\.textFieldState, textFieldState)
                    .previewDisplayName(
                        "Button: \(buttonState) " +
                        "Field: \(textFieldState)"
                    )
                }
            }
        }
    }
}