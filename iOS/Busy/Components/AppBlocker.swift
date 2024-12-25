import SwiftUI
import FamilyControls

struct AppBlocker: View {
    @Environment(Blocker.self) private var blocker

    @State var isPickerPresented: Bool = false
    @State var selection = FamilyActivitySelection()

    var settings: BlockerSettings {
        blocker.settings
    }

    var isEnabled: Bool {
        settings.isEnabled
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

                    Toggle(
                        isOn: .init(
                            get: { settings.isEnabled },
                            set: blocker.setStatus
                        )
                    ) {}
                    .tint(.backgroundBusy)
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
                    initSelection()
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
                .disabled(!isEnabled)
                .opacity(isEnabled ? 1 : 0.2)
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
            updateSelection()
        }
    }

    private func initSelection() {
        selection.applicationTokens = settings.applicationTokens
        selection.categoryTokens = settings.categoryTokens
        selection.webDomainTokens = settings.domainTokens
    }

    private func updateSelection() {
        blocker.update(by: selection)
    }
}
