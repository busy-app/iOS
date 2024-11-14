import SwiftUI

extension LoginFlow {
    struct LoginEnterPasswordView: View {
        @FocusState private var focusState: Field?

        @State private var password = ""
        @State private var confirmPassword = ""

        let email: String

        enum Field: Hashable {
            case password
        }

        var body: some View {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Image(.accountPassword)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 112)
                        .padding(.top, 32)

                    Text("You are logging in to the account:")
                        .font(.bodyPrimary)
                        .foregroundColor(.blackInvert)
                        .padding(.top, 16)

                    Text(email)
                        .font(.labelBold)
                        .foregroundColor(.blackInvert)
                        .padding(.top, 4)

                    CustomSecureTextField(
                        text: $password,
                        placeholder: "Password",
                        caption: .invalid("Incorrect password")
                    )
                    .padding(.top, 16)
                    .focused($focusState, equals: .password)
                    .submitLabel(.done)
                    .onSubmit { focusState = nil }
                }

                FilledButton("Log In", action: {})
                    .padding(.top, 16)

                Text("Forgot password?")
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
                    NavBarTitle("Enter password")
                }
            }
        }
    }
}

struct LoginEnterPasswordView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(ButtonState.allCases, id: \.self) { buttonState in
                ForEach(TextFieldState.allCases, id: \.self) { textFieldState in
                    NavigationStack {
                        LoginFlow.LoginEnterPasswordView(
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
