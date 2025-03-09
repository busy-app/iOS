import SwiftUI

import FamilyControls
import ManagedSettings

extension BusyApp.SettingsView {
    struct AppsSettingsControl: View {
        @Binding var settings: BlockerSettings

        @State var isAuthorized: Bool = false

        var body: some View {
            VStack(alignment: .leading, spacing: 0) {
                Toggle(isOn: $settings.isOn) {
                    Text("Block apps")
                        .font(.pragmaticaNextVF(size: 18))
                        .foregroundStyle(.whiteInvert)
                }
                .tint(.accent)

                Group {
                    if isAuthorized {
                        SelectAppsButton(settings: $settings)
                    } else {
                        PermissionsButton()
                    }
                }
                .padding(.top, 22)
            }
            .padding(12)
            .background(.transparentWhiteInvertQuinary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .onReceive(AuthorizationCenter.shared.$authorizationStatus) {
                isAuthorized = $0 == .approved
            }
            .task {
                isAuthorized =
                    AuthorizationCenter.shared.authorizationStatus == .approved
            }
        }
    }

    struct PermissionsButton: View {
        var body: some View {
            Button {
                Task {
                    try? await AuthorizationCenter
                        .shared
                        .requestAuthorization(for: .individual)
                }
            } label: {
                VStack(spacing: 8) {
                    HStack(spacing: 0) {
                        Image(.markInCircle)
                            .renderingMode(.template)
                        Text("Permission required")
                            .padding(.leading, 8)
                        Spacer()
                        Image(.arrowIcon)
                            .renderingMode(.template)
                            .padding(.leading, 8)
                    }
                    .foregroundStyle(.dangerPrimary)

                    Text(
                        "We use Screen Time to block distracting apps and " +
                        "notifications during your BUSY time. " +
                        "Your data remains private and secure."
                    )
                    .foregroundStyle(.transparentWhiteInvertPrimary)
                    .font(.pragmaticaNextVF(size: 16))
                    .multilineTextAlignment(.leading)
                    .padding(.top, 8)
                    .lineSpacing(8)
                }
            }
        }
    }

    struct SelectAppsButton: View {
        @Binding var settings: BlockerSettings

        @State private var showPicker: Bool = false
        @State private var selection = FamilyActivitySelection()

        var body: some View {
            Button {
                showPicker = true
            } label: {
                Group {
                    if settings.selectedCount > 0 {
                        SelectedApps(settings: settings)
                    } else {
                        AddApps()
                    }
                }
                .frame(height: 32)
            }
            .familyActivityPicker(
                isPresented: $showPicker,
                selection: $selection
            )
            .onChange(of: selection) {
                settings.applicationTokens = selection.applicationTokens
                settings.categoryTokens = selection.categoryTokens
                settings.domainTokens = selection.webDomainTokens
            }
            .task {
                selection.applicationTokens = settings.applicationTokens
                selection.categoryTokens = settings.categoryTokens
                selection.webDomainTokens = settings.domainTokens
            }
        }
    }

    struct AddApps: View {
        var body: some View {
            HStack {
                Spacer()
                Text("+ Add apps")
                Spacer()
            }
            .frame(maxHeight: .infinity)
            .padding(12)
            .font(.pragmaticaNextVF(size: 18))
            .foregroundStyle(.transparentWhiteInvertPrimary)
            .background(.transparentWhiteInvertQuinary)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay {
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(
                        style: StrokeStyle(lineWidth: 2, dash: [4])
                    )
                    .tint(.transparentWhiteInvertQuaternary)
            }
        }
    }

    struct SelectedApps: View {
        let settings: BlockerSettings

        var body: some View {
            HStack(spacing: 0) {
                AppsIcons(settings: settings)
                Spacer(minLength: 12)
                Text(settings.selectedCountString)
                    .font(.pragmaticaNextVF(size: 14))
                    .foregroundStyle(.transparentWhiteInvertSecondary)
                Image(.arrowIcon)
                    .opacity(0.3)
            }
            .padding(.vertical, 4)
        }
    }

    struct AppsIcons: View {
        let settings: BlockerSettings

        var body: some View {
            if settings.isAllSelected {
                Image(.appsIcon)
                    .resizable()
                    .scaledToFit()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 4) {
                        ForEach(
                            Array(settings.categoryTokens),
                            id: \.self
                        ) { token in
                            AppIcon {
                                Label(token)
                                    .padding(-1)
                            }
                        }

                        ForEach(
                            Array(settings.applicationTokens),
                            id: \.self
                        ) { token in
                            AppIcon {
                                Label(token)
                                    .padding(-6)
                            }
                        }
                    }
                    .padding(.horizontal, 12)
                }
                .mask(ScrollGradient())
                .padding(.horizontal, -12)
            }
        }

        struct AppIcon<Content: View>: View {
            let label: () -> Content

            @State private var scale: CGSize = .zero
            private var size: Double { 32 }

            var body: some View {
                Spacer()
                    .frame(width: size, height: size)
                    .overlay {
                        label()
                            .labelStyle(.iconOnly)
                            .onGeometryChange(for: CGSize.self) { geometry in
                                geometry.size
                            } action: {
                                scale = $0
                            }
                            .scaleEffect(
                                CGSize(
                                    width: size / scale.width,
                                    height: size / scale.height
                                )
                            )
                    }
            }
        }

        struct ScrollGradient: View {
            func getGradient(isForce: Bool) -> LinearGradient {
                LinearGradient(
                    gradient: Gradient(
                        colors:
                            [
                                Color.black,
                                Color.black.opacity(0.4),
                                Color.black.opacity(0)
                            ]
                    ),
                    startPoint: isForce ? .leading : .trailing,
                    endPoint: isForce ? .trailing : .leading
                )
            }

            var body: some View {
                HStack(spacing: 0) {
                    getGradient(isForce: false)
                        .frame(width: 12)

                    Rectangle()
                        .fill(Color.black)

                    getGradient(isForce: true)
                        .frame(width: 12)
                }
            }
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
