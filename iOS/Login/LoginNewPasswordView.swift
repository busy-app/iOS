import SwiftUI

extension LoginFlow {
    struct LoginNewPasswordView: View {
        @FocusState private var focusState: Field?

        @State private var password = ""
        @State private var confirmPassword = ""

        let email: String

        enum Field: Hashable {
            case password
            case confirmPassword
        }

        var body: some View {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Image(.passwordCreate)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 112)
                        .padding(.top, 32)

                    Text("Set a new password for the account:")
                        .font(.bodyPrimary)
                        .foregroundColor(.blackInvert)
                        .padding(.top, 16)

                    Text(email)
                        .font(.labelBold)
                        .foregroundColor(.blackInvert)
                        .padding(.top, 4)

                    CustomSecureTextField(
                        text: $password,
                        placeholder: "Enter Password",
                        caption: .always(
                            "At least 8 characters, including a number," +
                            " an uppercase letter, a lowercase letter," +
                            " and a special character (e.g., @, #, $, !)"
                        )
                    )
                    .padding(.top, 16)
                    .focused($focusState, equals: .password)
                    .onSubmit { focusState = .confirmPassword }
                    .submitLabel(.next)

                    CustomSecureTextField(
                        text: $confirmPassword,
                        placeholder: "Confirm password",
                        caption: .invalid("Passwords do not match")
                    )
                    .padding(.top, 16)
                    .focused($focusState, equals: .confirmPassword)
                    .onSubmit { focusState = nil }
                    .submitLabel(.done)
                }

                FilledButton("Submit", action: {})
                    .padding(.top, 16)

                Text("Back to login")
                    .font(.labelPrimary)
                    .foregroundColor(.brandPrimary)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.top, 40)

                Spacer()
            }
            .ignoresSafeArea(.keyboard)
            .onAppear { focusState = .password}
            .padding(16)
            .navAppearance {
                LeadingToolbarItems {
                    NavBarBack(action: {})
                }

                PrincipalToolbarItems {
                    NavBarTitle("Set new password")
                }
            }
        }
    }
}

struct LoginNewPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(ButtonState.allCases, id: \.self) { buttonState in
                ForEach(TextFieldState.allCases, id: \.self) { textFieldState in
                    NavigationStack {
                        LoginFlow.LoginNewPasswordView(
                            email: "user.email@gmail.com"
                        )
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
