import SwiftUI

struct CodeField: View {
    @Environment(\.codeFieldState) private var state

    @FocusState private var focusState: Int?

    @Binding var code: [String]
    let timeLeft: String // NOTE: Maybe use TimeInterval here
    let label: String
    let forceOpenKeyboard: Bool // NOTE: Not sure if this is necessary

    init(
        code: Binding<[String]>,
        timeLeft: String,
        label: String,
        forceOpenKeyboard: Bool = false
    ) {
        self._code = code
        self.timeLeft = timeLeft
        self.label = label
        self.forceOpenKeyboard = forceOpenKeyboard
    }

    var body: some View {
        if state == .expired {
            VStack(spacing: 12) {
                Image(.warning)

                Text("Your verification code has expired")
                    .font(.titleSecondary)
                    .foregroundColor(.dangerPrimary)
            }
        } else {
            VStack(spacing: 8) {
                HStack {
                    Text(label)

                    Spacer()

                    Text("Expires in \(timeLeft)")
                }
                .font(.labelSecondary)
                .foregroundColor(.blackInvert)

                HStack(spacing: 18) {
                    ForEach(0..<code.count, id: \.self) { index in
                        SymbolField(
                            code: $code,
                            isCorrect: state == .default,
                            index: index
                        ) { focusState = $0 }
                        .focused($focusState, equals: index)
                    }
                }
                .frame(maxHeight: .infinity)

                Text("Incorrect code")
                    .font(.labelSecondary)
                    .foregroundColor(.dangerPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .opacity(state == .default ? 0 : 1)
            }
            .onAppear {
                if forceOpenKeyboard {
                    focusState = 0
                } else {
                    focusState = nil
                }
            }
        }
    }
}

struct CodeField_Previews: PreviewProvider {
    static var previews: some View {
        @State var code: [String] = ["1", "2", "3", "4", "5", "6"]

        VStack {
            ForEach(CodeFieldState.allCases, id: \.self) { state in
                CodeField(
                    code: $code,
                    timeLeft: "9:59",
                    label: "Verification code"
                )
                .frame(height: 100)
                .environment(\.codeFieldState, state)
            }
        }
        .padding()
    }
}
