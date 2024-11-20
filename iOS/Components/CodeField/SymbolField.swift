import SwiftUI
import UIKit

struct SymbolField: UIViewRepresentable {
    @Binding var code: [String]

    let isCorrect: Bool
    let index: Int
    let onChangeFocus: (Int?) -> Void

    func makeUIView(context: Context) -> UITextField {
        let textField = BackwardDetectTextField()
        textField.onBackward = context.coordinator.processBackward
        textField.delegate = context.coordinator
        textField.inputAccessoryView = createToolbar(with: context.coordinator)

        setStyle(for: textField)
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = code[index]
        setStyle(for: uiView)
    }

    private func setStyle(for textField: UITextField) {
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 8
        textField.keyboardType = .numberPad
        textField.textAlignment = .center

        textField.backgroundColor = UIColor(
            isCorrect
                ? .neutralSeptenary
                : .dangerTertiary
        )

        textField.layer.borderColor = UIColor(
            isCorrect
                ? .neutralQuinary
                : .dangerSecondary
        ).cgColor

        textField.tintColor = UIColor(.neutralTertiary)
        textField.textColor = UIColor(.blackInvert)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(textField: self)
    }

    private func createToolbar(with coordinator: Coordinator) -> UIToolbar {
        let toolbar = UIToolbar(
            frame: CGRect(
                x: 0,
                y: 0,
                width: UIScreen.main.bounds.width,
                height: 44
            )
        )

        let pasteButton = UIBarButtonItem(
            title: "Paste from clipboard",
            style: .done,
            target: coordinator,
            action: #selector(Coordinator.pasteCodeFromClipboard)
        )

        let flexSpace = UIBarButtonItem(
            barButtonSystemItem: .flexibleSpace,
            target: nil,
            action: nil
        )

        toolbar.setItems([flexSpace, pasteButton, flexSpace], animated: false)

        return toolbar
    }

    class Coordinator: NSObject, UITextFieldDelegate {
        let parent: SymbolField

        init(textField: SymbolField) {
            self.parent = textField
        }

        func textFieldDidBeginEditing(_ textField: UITextField) {
            self.updateFocus(self.parent.index)
        }

        // NOTE: Refactor for more clear
        func textField(
            _ textField: UITextField,
            shouldChangeCharactersIn range: NSRange,
            replacementString string: String
        ) -> Bool {
            let currentText = textField.text ?? ""

            guard let textRange = Range(range, in: currentText) else {
                return false
            }

            if string.count > 1 {
                let pastedText = string.filter { $0.isNumber }
                let codeLength = self.parent.code.count
                let availableSpace = codeLength - self.parent.index
                let clippedText = pastedText.prefix(availableSpace)

                for (offset, char) in clippedText.enumerated() {
                    let index = self.parent.index + offset
                    self.parent.code[index] = String(char)
                }

                let nextIndex = self.parent.index + clippedText.count
                updateFocus(nextIndex < codeLength ? nextIndex : nil)
                return false
            }

            let filteredText = currentText
                .replacingCharacters(in: textRange, with: string)
                .filter { $0.isNumber }

            if !filteredText.isEmpty, let newChar = filteredText.last {
                if self.parent.code[self.parent.index].isEmpty {
                    self.parent.code[self.parent.index] = String(newChar)
                    let nextIndex = self.parent.index + 1
                    updateFocus(nextIndex < self.parent.code.count ? nextIndex : nil)
                } else {
                    if range.location == 0, let firstChar = filteredText.first {
                        self.parent.code[self.parent.index] = String(firstChar)
                    } else {
                        let nextIndex = self.parent.index + 1
                        if nextIndex < self.parent.code.count {
                            self.parent.code[nextIndex] = String(newChar)
                        }
                        updateFocus(nextIndex < self.parent.code.count - 1 ? nextIndex: nil)
                    }
                }
            } else {
                if range.length == 1 && string.isEmpty {
                    self.parent.code[self.parent.index] = ""
                    if self.parent.index > 0 {
                        updateFocus(self.parent.index - 1)
                    }
                }
            }

            return false
        }

        func processBackward() {
            if self.parent.index > 0 {
                updateFocus(self.parent.index - 1)
            }
        }

        private func updateFocus(_ index: Int?) {
            DispatchQueue.main.async {
                self.parent.onChangeFocus(index)
            }
        }

        @objc func pasteCodeFromClipboard() {
            guard let text = UIPasteboard.general.string else { return }
            if text.isEmpty { return }

            let filteredText = text.filter { $0.isNumber }
            let codeLength = self.parent.code.count
            let clippedText = filteredText.prefix(codeLength)
            var codeArray = clippedText.map(String.init)

            let missingCount = codeLength - codeArray.count
            if missingCount > 0 {
                codeArray.append(
                    contentsOf: Array(repeating: "", count: missingCount)
                )
            }

            DispatchQueue.main.async {
                self.parent.code = codeArray
                self.parent.onChangeFocus(codeArray.count - missingCount - 1)
            }
        }
    }
}

private class BackwardDetectTextField: UITextField {
    var onBackward: (() -> Void)?

    override init(frame: CGRect) {
        onBackward = nil
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func deleteBackward() {
        if self.selectedTextRange?.start == self.beginningOfDocument {
            onBackward?()
        }
        super.deleteBackward()
    }
}
