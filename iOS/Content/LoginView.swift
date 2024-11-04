import SwiftUI

struct LoginView: View {
    @State var email: String = ""
    @State var password: String = ""

    var body: some View {
        VStack(spacing: 0) {
            Image(.cloud)

            Spacer()

            VStack(spacing: 24) {
                VStack(spacing: 12) {
                    EmailField(value: $email)
                    PasswordField(value: $password)
                }

                HStack {
                    Spacer()
                    Button {
                    } label: {
                        Text("Forgot Password?")
                            .font(.ppNeueMontrealRegular(size: 18))
                    }
                }

                FilledButton("LOG IN") {
                }
            }

            VStack(spacing: 18) {
                HStack(alignment: .center, spacing: 12) {
                    HorizontalLine()
                        .foregroundStyle(.neutralQuinary)

                    Text("Or Login with")
                        .font(.ppNeueMontrealRegular(size: 18))
                        .foregroundStyle(.neutralTertiary)
                        .layoutPriority(.infinity)

                    HorizontalLine()
                        .foregroundStyle(.neutralQuinary)
                }
                .padding(.top, 57)

                HStack(spacing: 12) {
                    Button {
                    } label: {
                        LogoContainer {
                            Image(.appleLogo)
                        }
                    }

                    Button {
                    } label: {
                        LogoContainer {
                            Image(.googleLogo)
                        }
                    }
                }
            }

            HStack {
                Text("Don’t have an account?")
                    .font(.ppNeueMontrealRegular(size: 18))
                    .foregroundStyle(.neutralTertiary)

                Button {
                } label: {
                    Text("SIGN UP")
                        .font(.ppNeueMontrealRegular(size: 16))
                        .foregroundStyle(.brandPrimary)
                }
            }
            .padding(.vertical, 46)
        }
        .padding(.horizontal, 24)
        .background(.whiteInvert)
    }

    struct HorizontalLine: View {
        var body: some View {
            Rectangle()
                .frame(height: 1)
        }
    }

    struct LogoContainer: View {
        @ViewBuilder var content: () -> Image

        var body: some View {
            VStack {
                content()
            }
            .frame(minHeight: 60)
            .frame(maxWidth: .infinity)
            .background(.transparentBlackInvertQuaternary)
            .cornerRadius(4)
        }
    }

    struct EmailField: View {
        @Binding var value: String

        var body: some View {
            TextField(
                "",
                text: $value,
                prompt: Text("Email").foregroundColor(.neutralSecondary)
            )
            .textFieldStyle
        }
    }

    struct PasswordField: View {
        @Binding var value: String

        var body: some View {
            SecureField(
                "",
                text: $value,
                prompt: Text("Password").foregroundColor(.neutralSecondary)
            )
            .textFieldStyle
        }
    }

}

private extension View {
    var textFieldStyle: some View {
        self
            .font(.jetBrainsMonoRegular(size: 16))
            .padding(.horizontal, 12)
            .padding(.vertical, 14)
            .background(.neutralSeptenary)
            .cornerRadius(8)
            .overlay {
                RoundedRectangle(cornerRadius: 8)
                    .stroke(.neutralQuinary)
            }
    }
}

#Preview {
    MainView()
}
