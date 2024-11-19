import ManagedSettings
import ManagedSettingsUI
import UIKit

class ShieldConfigurationExtension: ShieldConfigurationDataSource {
    override func configuration(
        shielding application: Application
    ) -> ShieldConfiguration {
        .init(
            backgroundBlurStyle: .regular,
            backgroundColor: .gray,
            icon: .init(systemName: "app")?.withTintColor(.magenta),
            title: .init(
                text: "\(application.name) blocked by Busy App",
                color: .red
            ),
            subtitle: .init(
                text: "You can disable Busy mode or just open the app",
                color: .cyan),
            primaryButtonLabel: .init(text: "Disable Busy", color: .red),
            primaryButtonBackgroundColor: .blue,
            secondaryButtonLabel: .init(text: "Open the app", color: .green)
        )
    }

    override func configuration(
        shielding application: Application,
        in category: ActivityCategory
    ) -> ShieldConfiguration {
        .init(
            backgroundBlurStyle: .regular,
            backgroundColor: .gray,
            icon: .init(systemName: "rectangle.3.group")?.withTintColor(.magenta),
            title: .init(
                text: "\(category.name) blocked by Busy App",
                color: .red
            ),
            subtitle: .init(
                text: "You can disable Busy mode or just the group",
                color: .cyan),
            primaryButtonLabel: .init(text: "Disable Busy", color: .red),
            primaryButtonBackgroundColor: .blue,
            secondaryButtonLabel: .init(text: "Enable the group", color: .green)
        )
    }

//    override func configuration(shielding webDomain: WebDomain) -> ShieldConfiguration {
//        // Customize the shield as needed for web domains.
//        configuration
//    }
//    
//    override func configuration(shielding webDomain: WebDomain, in category: ActivityCategory) -> ShieldConfiguration {
//        // Customize the shield as needed for web domains shielded because of their category.
//        configuration
//    }
}

extension Application {
    var name: String {
        localizedDisplayName ?? "App"
    }
}

extension ActivityCategory {
    var name: String {
        localizedDisplayName ?? "Category"
    }
}
