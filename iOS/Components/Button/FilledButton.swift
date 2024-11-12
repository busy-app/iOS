import SwiftUI

// NOTE: Better naming
struct FilledButton<Label: View, Leading: View, Trailing: View>: View {
    @Environment(\.buttonState) var state

    let action: () -> Void
    @ViewBuilder let label: () -> Label
    @ViewBuilder let leading: () -> Leading
    @ViewBuilder let trailing: () -> Trailing

    init(
        action: @escaping @MainActor () -> Void,
        @ViewBuilder label: @escaping () -> Label,
        @ViewBuilder leading: @escaping () -> Leading = { EmptyView() },
        @ViewBuilder trailing: @escaping () -> Trailing = { EmptyView() }
    ) {
        self.action = action
        self.label = label
        self.leading = leading
        self.trailing = trailing
    }

    var body: some View {
        Button {
            action()
        } label: {
            HStack(spacing: 0) {
                Spacer()

                leading()
                    .padding(.trailing, 12)
                    .frame(width: 24, height: 24)

                label()
                    .lineLimit(1)
                    .font(.labelPrimary)
                    .foregroundColor(.whiteOnContent)

                Group {
                    if state == .loading {
                        AnimatedLoader(color: .whiteInvert)
                            .frame(width: 16, height: 16)
                    } else {
                        trailing()
                    }
                }
                .padding(.leading, 12)
                .frame(width: 24, height: 24)

                Spacer()
            }
            .frame(height: 44)
            .background(.brandPrimary)
            .cornerRadius(8)
        }
        .opacity(state.isDisable ? 0.5 : 1)
        .disabled(state.isDisable)
    }
}

extension FilledButton where Label == Text {
    init(
        _ text: String,
        @ViewBuilder leading: @escaping () -> Leading = { EmptyView() },
        @ViewBuilder trailing: @escaping () -> Trailing = { EmptyView() },
        action: @escaping @MainActor () -> Void
    ) {
        self.action = action
        self.label = { Text(text) }
        self.leading = leading
        self.trailing = trailing
    }
}

struct FilledButton_Preview: PreviewProvider {
    static var previews: some View {
        Group {
            ForEach(ButtonState.allCases, id: \.self) { state in
                VStack {
                    FilledButton("Continue with email") {}
                    FilledButton(
                        "Continue with email",
                        leading: {
                            Image(.password)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.whiteInvert)
                                .frame(width: 16, height: 16)
                        }
                    ) {}
                    FilledButton(
                        "Continue with email",
                        trailing: {
                            Image(.password)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.whiteInvert)
                                .frame(width: 16, height: 16)
                        }
                    ) {}
                    FilledButton(
                        "Continue with email",
                        leading: {
                            Image(.password)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.whiteInvert)
                                .frame(width: 16, height: 16)
                        },
                        trailing: {
                            Image(.password)
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(.whiteInvert)
                                .frame(width: 16, height: 16)
                        }
                    ) {}
                }
                .padding()
                .environment(\.buttonState, state)
                .previewDisplayName("Button \(state)")
            }
        }
    }
}
