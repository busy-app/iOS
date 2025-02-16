import SwiftUI

struct CustomToggle: View {
    let title: String
    let description: String
    @Binding var isOn: Bool

    var body: some View {
        HStack {
            Toggle(isOn: $isOn) {
                VStack(alignment: .leading, spacing: 8) {
                    Text(title)
                        .lineLimit(1)
                        .foregroundStyle(.whiteInvert)
                        .font(.pragmaticaNextVF(size: 18))
                    Text(description)
                        .fixedSize(horizontal: false, vertical: true)
                        .foregroundStyle(.neutralSecondary)
                        .font(.pragmaticaNextVF(size: 16))
                }
            }
            .tint(.accent)
        }
    }
}

#Preview {
    @Previewable @State var isOn = true

    CustomToggle(
        title: "Title title title title title title",
        description: "Description description description description ",
        isOn: $isOn
    )
    .colorScheme(.light)
    .padding(14)
}
