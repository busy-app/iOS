import SwiftUI

extension LoginFlow {
    struct LoginForgotPasswordView: View {
        @Environment(\.codeFieldState) private var codeFieldState

        @State private var code = ["", "", "", "", "", ""]

        let email: String
        let timeLeft: String

        private var actionText: String {
            switch codeFieldState {
            case .default, .invalid: return "Continue"
            case .expired: return "Resend email"
            }
        }

        var body: some View {
            VStack(spacing: 0) {
                Image(.verifyEmail)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 112)
                    .padding(.top, 32)

                Text("We’ve sent a verification email to")
                    .font(.bodyPrimary)
                    .foregroundColor(.blackInvert)
                    .padding(.top, 16)

                Text(email)
                    .font(.labelBold)
                    .foregroundColor(.blackInvert)
                    .padding(.top, 4)

                CodeField(
                    code: $code,
                    timeLeft: timeLeft,
                    label: "Password reset code:",
                    forceOpenKeyboard: true
                )
                .frame(height: 100)
                .padding(.top, 16)

                FilledButton(actionText, action: {})
                    .padding(.top, 16)

                VStack(alignment: .leading, spacing: 0) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Check your inbox (and spam folder) to proceed")

                        Text(
                            "\u{2022} To reset password via code, enter " +
                            "the code we’ve sent you in the email."
                        )
                        .padding(.leading, 4)

                        Text(
                            "\u{2022} To reset password via link, click the " +
                            "“Set new password” button in the email."
                        )
                        .padding(.leading, 4)

                    }
                    .font(.bodySecondary)
                    .foregroundColor(.neutralSecondary)

                    Text("Resend email")
                        .font(.labelPrimary)
                        .foregroundColor(.brandPrimary)
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .padding(.top, 40)

                    Spacer()

                }
                .padding(.top, 32)
                .opacity(codeFieldState == .expired ? 0 : 1)
            }
            .padding(16)
            .navAppearance {
                LeadingToolbarItems {
                    NavBarBack(action: {})
                }

                PrincipalToolbarItems {
                    NavBarTitle("Forgot your password?")
                }
            }
        }
    }
}

struct LoginForgotPassword_Previews: PreviewProvider {
    static var previews: some View {
        @State var email: String = "user.email@gmail.com"
        @State var timeLeft: String = "9:55"

        Group {
            ForEach(CodeFieldState.allCases, id: \.self) { codeFieldState in
                ForEach(ButtonState.allCases, id: \.self) { buttonState in
                    NavigationStack {
                        LoginFlow.LoginForgotPasswordView(
                            email: email,
                            timeLeft: timeLeft
                        )
                    }
                    .environment(\.codeFieldState, codeFieldState)
                    .environment(\.buttonState, buttonState)
                    .previewDisplayName(
                        "Button: \(buttonState) " +
                        "Code: \(codeFieldState)"
                    )
                }
            }
        }
    }
}
