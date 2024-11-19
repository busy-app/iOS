import ManagedSettings
import ManagedSettingsUI
import UIKit

class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    func configuration(
        shielding name: String
    ) -> ShieldConfiguration {
        .init(
            backgroundBlurStyle: nil,
            backgroundColor: nil,
            icon: nil,
            title: .init(
                text: "\(name) locked by Busy App",
                color: .red
            ),
            subtitle: .init(
                text: "Disable Busy Mode to unlock",
                color: .white
            ),
            primaryButtonLabel: nil,
            primaryButtonBackgroundColor: nil,
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
        configuration(shielding: category.name)
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
