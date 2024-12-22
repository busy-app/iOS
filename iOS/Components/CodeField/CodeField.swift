import SwiftUI

struct CodeField: View { // NOTE: Rename, because it's not only a field
    @Environment(\.codeFieldState) private var state

    @State private var currentIndex: Int?
    @FocusState private var isFocused: Int?

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
                        .onTapGesture {
                            currentIndex = nil
                        }
                }
                .font(.labelSecondary)
                .foregroundColor(.blackInvert)

                HStack(spacing: 18) {
                    ForEach(0..<code.count, id: \.self) { index in
                        SymbolFieldNew(
                            index: index,
                            codeLength: code.count,
                            symbol: $code[index],
                            currentIndex: $currentIndex
                        )
                        .focused($isFocused, equals: index)
                    }
                }

                Text("Incorrect code")
                    .font(.labelSecondary)
                    .foregroundColor(.dangerPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .opacity(state == .default ? 0 : 1)
            }
            .onAppear {
                currentIndex = forceOpenKeyboard ? 0 : nil
            }
            .onChange(of: currentIndex) { _, index in
                isFocused = currentIndex
            }
            .toolbar {
                ToolbarItem(placement: .keyboard) {
                    HStack {
                        Spacer()
                        Button(action: pasteFromClipboard) {
                            Text("Paste code from clipboard")
                                .font(.labelSecondary)
                                .foregroundColor(.brandPrimary)
                        }
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }


    private func pasteFromClipboard() {
        guard
            let pasteboard = UIPasteboard
                .general
                .string?
                .filter({ $0.isNumber })
        else { return }

        currentIndex = nil

        for (index, _) in code.enumerated() {
            code[index] = .emptySymbol
        }

        for (index, character) in pasteboard.enumerated() {
            guard index < code.count else { break }
            code[index] = String(character)
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
                    label: "Verification code",
                    forceOpenKeyboard: true
                )
                .environment(\.codeFieldState, state)
            }
        }
        .padding()
    }
}

// NOTE: Move to extensions file
extension String {
    static let emptySymbol = "\u{200B}"
}
