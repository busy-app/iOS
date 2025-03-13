import ManagedSettings
import ManagedSettingsUI
import UIKit
import SwiftUI

class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    let shieldAttemptService = ShieldAttemptService.shared

    func configuration(
        shielding name: String
    ) -> ShieldConfiguration {
        shieldAttemptService.add(by: name)
        let blocked = shieldAttemptService.count(for: name, since: .today)

        return .init(
            backgroundBlurStyle: .systemUltraThinMaterialDark,
            backgroundColor: .background,
            icon: .appIcon,
            title: .init(
                text: "\(name) 🔒 blocked",
                color: .white
            ),
            subtitle: .init(
                text: "\(blocked)x today",
                color: .white
            ),
            primaryButtonLabel: .init(text: "Keep BUSY", color: .white),
            primaryButtonBackgroundColor: .buttonBackground,
            secondaryButtonLabel: nil
        )
    }

    override func configuration(
        shielding application: Application
    ) -> ShieldConfiguration {
        configuration(shielding: application.name)
    }

    override func configuration(
        shielding application: Application,
        in category: ActivityCategory
    ) -> ShieldConfiguration {
        configuration(shielding: application.name)
    }

    override func configuration(
        shielding webDomain: WebDomain
    ) -> ShieldConfiguration {
        configuration(shielding: webDomain.name)
    }

    override func configuration(
        shielding webDomain: WebDomain,
        in category: ActivityCategory
    ) -> ShieldConfiguration {
        configuration(shielding: category.name)
    }
}

extension Application {
    var name: String {
        localizedDisplayName ?? "App"
    }
}

extension WebDomain {
    var name: String {
        domain ?? "Domain"
    }
}

extension ActivityCategory {
    var name: String {
        localizedDisplayName ?? "Category"
    }
}
