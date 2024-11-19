import ManagedSettings

class ShieldActionExtension: ShieldActionDelegate {
    var shield: ShieldSettings {
        get { ManagedSettingsStore().shield }
        set { ManagedSettingsStore().shield = newValue }
    }

    override func handle(
        action: ShieldAction,
        for application: ApplicationToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void
    ) {
        print("application", application)
        switch action {
        case .primaryButtonPressed:
            disableShield()
            completionHandler(.defer)
        case .secondaryButtonPressed:
            enableApplication(application)
            completionHandler(.defer)
        @unknown default:
            fatalError()
        }
    }

    override func handle(
        action: ShieldAction,
        for webDomain: WebDomainToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void
    ) {
        print("domain", webDomain)
        switch action {
        case .primaryButtonPressed:
            disableShield()
            completionHandler(.defer)
        case .secondaryButtonPressed:
            enableDomain(webDomain)
            completionHandler(.defer)
        @unknown default:
            fatalError()
        }
    }

    override func handle(
        action: ShieldAction,
        for category: ActivityCategoryToken,
        completionHandler: @escaping (ShieldActionResponse) -> Void
    ) {
        print("category", category)
        switch action {
        case .primaryButtonPressed:
            disableShield()
            completionHandler(.defer)
        case .secondaryButtonPressed:
            enableCaregory(category)
            completionHandler(.defer)
        @unknown default:
            fatalError()
        }
    }

    // MARK: Filters

    private func disableShield() {
        shield.applications = nil
        shield.applicationCategories = nil
        shield.webDomains = nil
        shield.webDomainCategories = nil
    }

    private func enableApplication(_ application: ApplicationToken) {
        shield.applications?.remove(application)
    }

    private func enableDomain(_ domain: WebDomainToken) {
        shield.webDomains?.remove(domain)
    }

    private func enableCaregory(_ category: ActivityCategoryToken) {
        switch shield.applicationCategories {
        case let .specific(categories, except: applications):
            shield.applicationCategories =
                .specific(
                    categories.subtracting([category]),
                    except: applications
                )
        default:
            fatalError()
        }
    }
}
