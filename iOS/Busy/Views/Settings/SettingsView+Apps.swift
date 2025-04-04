import SwiftUI

import FamilyControls
import ManagedSettings

extension BusyApp.SettingsView {
    // TODO: Think about logic when user revokes permission
    struct AppsSettingsControl: View {
        @Binding var settings: BlockerSettings

        @State private var isAuthorized: Bool = false
        @State private var showPicker: Bool = false
        @State private var selection = FamilyActivitySelection()

        private var blockedApps: String {
            guard isAuthorized else { return "Not Selected" }

            switch (settings.categoryTokens, settings.applicationTokens) {
            case (_, _) where settings.isAllSelected:
                return "All"
            case ([], []):
                return "Not Selected"
            case (let categories, []):
                return "\(categories.count) categories"
            case ([], let apps):
                return "\(apps.count) apps"
            case (let categories, let apps):
                return "\(categories.count) categories, \(apps.count) apps"
            }
        }

        var body: some View {
            Button(action: onSelect) {
                HStack(spacing: 0) {
                    Text("Block apps")
                        .font(.pragmaticaNextVF(size: 18))
                        .foregroundStyle(.whiteInvert)

                    Spacer()

                    HStack(spacing: 0) {
                        Text(blockedApps)
                            .font(.pragmaticaNextVF(size: 16))
                            .foregroundStyle(.transparentWhiteInvertPrimary)

                        Image(.arrowIcon)
                            .opacity(0.3)
                    }
                }
                .padding(12)
                .background(.transparentWhiteInvertQuinary)
                .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .task {
                let status = AuthorizationCenter.shared.authorizationStatus
                isAuthorized = status == .approved
            }
            .sheet(isPresented: $showPicker) {
                FamilyActivityPicker(selection: $selection)
                    .overlay(alignment: .topTrailing) {
                        Button("Done") {
                            showPicker = false
                        }
                        .padding(18)
                        .fontWeight(.medium)
                    }
            }
            .onChange(of: selection) {
                settings.applicationTokens = selection.applicationTokens
                settings.categoryTokens = selection.categoryTokens
                settings.domainTokens = selection.webDomainTokens
            }
            .onReceive(AuthorizationCenter.shared.$authorizationStatus) {
                isAuthorized = $0 == .approved
            }
        }

        private func onSelect() {
            openSelection()
            
            if !isAuthorized {
                Task { @MainActor in
                    try? await AuthorizationCenter
                        .shared
                        .requestAuthorization(for: .individual)
                }
            }
        }

        private func openSelection() {
            selection.applicationTokens = settings.applicationTokens
            selection.categoryTokens = settings.categoryTokens
            selection.webDomainTokens = settings.domainTokens
            showPicker = true
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
