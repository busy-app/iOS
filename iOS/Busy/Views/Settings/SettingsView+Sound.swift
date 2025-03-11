import SwiftUI

extension BusyApp.SettingsView {
    struct SoundSettingsControl: View {
        @Binding var soundSettings: SoundSettings

        var isOn: Binding<Bool> {
            .init(
                get: {
                    soundSettings.alertBeforeWork || 
                    soundSettings.alertBeforeRest
                },
                set: {
                    soundSettings.alertBeforeWork = $0
                    soundSettings.alertBeforeRest = $0
                }
            )
        }

        var body: some View {
            HStack(alignment: .top, spacing: 12) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("Sound")
                        .font(.pragmaticaNextVF(size: 18))
                        .foregroundStyle(.whiteInvert)

                    Text(
                        "Get notified when current interval ends and " +
                        "it's time to start the next one"
                    )
                    .padding(.top, 8)
                    .multilineTextAlignment(.leading)
                    .lineSpacing(18 * 0.3)
                    .font(.pragmaticaNextVF(size: 14))
                    .foregroundStyle(.transparentWhiteInvertSecondary)
                }

                Spacer()

                Toggle(isOn: isOn) {
                    EmptyView()
                }
                .labelsHidden()
                .tint(.accent)
            }
            .padding(12)
            .background(.transparentWhiteInvertQuinary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
}

#Preview {
    @Previewable @State var isPresented: Bool = true
    @Previewable @State var settings: BusySettings = .init()

    Button("Show") {
        isPresented = true
    }
    .sheet(isPresented: $isPresented) {
        BusyApp.SettingsView(settings: $settings)
            .colorScheme(.light)
            .presentationDragIndicator(.visible)
    }
}
