import SwiftUI

struct LoginFlow: View {
    @State private var path = NavigationPath()

    enum Destination: Hashable {
        case createAccount(email: String)
        case createPassword(email: String)
        case enterPassword(email: String)
        case forgotPassword(email: String)
        case newPassword(email: String)
        case verifyEmail(email: String)
    }

    var body: some View {
        NavigationStack(path: $path) {
            LoginToCloudView()
                .navigationDestination(for: Destination.self) { destination in
                    switch destination {
                    case .createAccount(let email):
                        LoginCreateAccountView(email: email)
                    case .createPassword(let email):
                        LoginCreatePasswordView(email: email)
                    case .enterPassword(let email):
                        LoginEnterPasswordView(email: email)
                    case .forgotPassword(let email):
                        LoginForgotPasswordView(email: email)
                    case .newPassword(let email):
                        LoginNewPasswordView(email: email)
                    case .verifyEmail(let email):
                        LoginVerifyEmailView(email: email)
                    }
                }
        }
        .environment(\.path, $path)
    }
}
