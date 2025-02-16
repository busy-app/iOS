import SwiftUI
import FamilyControls

struct AppBlocker: View {
    @State var isPickerPresented: Bool = false
    @State var selection = FamilyActivitySelection()

    @Binding private var settings: BlockerSettings

    var isOn: Bool {
        settings.isOn
    }

    var blockingCount: Int {
        settings.applicationTokens.count +
        settings.categoryTokens.count +
        settings.domainTokens.count
    }

    var body: some View {
        VStack {
            VStack(spacing: 0) {
                HStack {
                    Text("App blocker")
                        .font(.pragmaticaNextVF(size: 22))

                    Toggle(isOn: $settings.isOn) {}
                }
                .padding(.top, 12)

                Text(
                    "Distracting apps automatically " +
                    "block when BUSY is activated"
                )
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundStyle(.neutralTertiary)
                .font(.pragmaticaNextVF(size: 16))
                .padding(.top, 10)

                Button {
                    selection.applicationTokens = settings.applicationTokens
                    selection.categoryTokens = settings.categoryTokens
                    selection.webDomainTokens = settings.domainTokens
                    isPickerPresented = true
                } label: {
                    HStack(spacing: 0) {
                        Text("Select apps & categories")
                        Spacer()
                        Text("\(blockingCount)")
                        Image(systemName: "chevron.right")
                            .padding(.leading, 10)
                            .padding(.bottom, 2)
                    }
                    .foregroundColor(.blackInvert)
                    .font(.pragmaticaNextVF(size: 16))
                }
                .padding(.top, 26)
                .padding(.bottom, 12)
                .disabled(!isOn)
                .opacity(isOn ? 1 : 0.2)
            }
            .padding(.horizontal, 12)
        }
        .background(.transparentBlackInvertQuinary)
        .cornerRadius(8)
        .familyActivityPicker(
            isPresented: $isPickerPresented,
            selection: $selection
        )
        .onChange(of: selection) {
            settings.applicationTokens = selection.applicationTokens
            settings.categoryTokens = selection.categoryTokens
            settings.domainTokens = selection.webDomainTokens
        }
    }
}
