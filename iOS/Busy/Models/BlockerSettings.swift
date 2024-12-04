import ManagedSettings
import FamilyControls

struct BlockerSettings: Codable, RawRepresentable {
    var isEnabled: Bool = false
    var applicationTokens: Set<ApplicationToken> = .init()
    var categoryTokens: Set<ActivityCategoryToken> = []
    var domainTokens: Set<WebDomainToken> = []

    enum CodingKeys: CodingKey {
        case isEnabled
        case applicationTokens
        case categoryTokens
        case domainTokens
    }

    init() {}

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isEnabled = try container.decode(Bool.self, forKey: .isEnabled)
        applicationTokens = try container
            .decode(Set<ApplicationToken>.self, forKey: .applicationTokens)
        categoryTokens = try container
            .decode(Set<ActivityCategoryToken>.self, forKey: .categoryTokens)
        domainTokens = try container
            .decode(Set<WebDomainToken>.self, forKey: .domainTokens)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isEnabled, forKey: .isEnabled)
        try container.encode(applicationTokens, forKey: .applicationTokens)
        try container.encode(categoryTokens, forKey: .categoryTokens)
        try container.encode(domainTokens, forKey: .domainTokens)
    }
}
