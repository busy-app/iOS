import SwiftUI

extension LoginFlow {
    struct LoginCreateAccountView: View {
        @Environment(\.path) private var path

        let email: String

        var body: some View {
            VStack(spacing: 0) {
                VStack(spacing: 0) {
                    Image(.accountCreate)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 112)
                        .padding(.top, 32)

                    Text("Busy Cloud account for this email doesn’t exist yet:")
                        .font(.bodyPrimary)
                        .foregroundColor(.blackInvert)
                        .padding(.top, 16)

                    Text(email)
                        .font(.labelBold)
                        .foregroundColor(.blackInvert)
                        .padding(.top, 4)

                    Spacer()
                }
                .frame(height: 260)

                FilledButton("Create Account") {
                    path.append(Destination.createPassword(email: email))
                }
                .padding(.top, 32)

                Spacer()
            }
            .padding(16)
            .topBar {
                NavigationBackButton()

                NavigationTitle("Create Account?")
            }
        }
    }
}

struct LoginCreateAccountView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(ButtonState.allCases, id: \.self) { state in
                NavigationStack {
                    LoginFlow.LoginCreateAccountView(
                        email: "user.email@gmail.com"
                    )
                }
                .environment(\.buttonState, state)
                .previewDisplayName("Button: \(state)")
            }
        }
    }
}
