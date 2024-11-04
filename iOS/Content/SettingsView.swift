import SwiftUI

struct SettingsView: View {
    @AppStorage("isPaired") var isPaired: Bool = false

    @AppStorage("devMode") var devMode = false
    @AppStorage("autoUpdate") var autoUpdate = false
    @AppStorage("darkTheme") var darkTheme = false

    var body: some View {
        VStack {
            ScrollView {
                VStack(spacing: 24) {
                    HStack {
                        Text("Firmware version")
                        Spacer(minLength: 12)
                        Text("BSB_OR1.5")
                            .foregroundStyle(.neutralSecondary)
                    }

                    Divider()
                        .padding(.horizontal, 12)
                        .background(.neutralQuinary)

                    Toggle("Dev mode", isOn: $devMode)

                    Divider()
                        .padding(.horizontal, 12)
                        .background(.neutralQuinary)

                    Toggle("Automatic firmware update", isOn: $autoUpdate)

                    Divider()
                        .padding(.horizontal, 12)
                        .background(.neutralQuinary)

                    Toggle("Dark theme", isOn: $darkTheme)
                }
                .font(.jetBrainsMonoRegular(size: 16))
                .padding(.horizontal, 14)
                .padding(.vertical, 24)
            }

            Button {
                isPaired = false
            } label: {
                Text("FORGET THIS DEVICE")
                    .foregroundStyle(.dangerPrimary)
            }
            .padding(.bottom, 30)
        }
    }

    struct Row<Leading, Trailing>: View where Leading: View, Trailing: View {
        @ViewBuilder var leading: () -> Leading
        @ViewBuilder var trailing: () -> Trailing

        init (
            leading: @escaping () -> Leading,
            trailing: @escaping () -> Trailing
        ) {
            self.leading = leading
            self.trailing = trailing
        }

        var body: some View {
            HStack {
                leading()
                Spacer(minLength: 0)
                trailing()
            }
            .padding(12)
            .font(.jetBrainsMonoRegular(size: 16))
            .foregroundStyle(.blackInvert)
        }
    }
}
