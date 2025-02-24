import ManagedSettings
import FamilyControls

struct BusySettings: Codable, RawRepresentable {
    var name: String = "BUSY"
    var time: Duration = .minutes(90)
    var intervals: IntervalsSettings = .init()
    var blocker: BlockerSettings = .init()
    var sound: SoundSettings = .init()

    enum CodingKeys: CodingKey {
        case name
        case time
        case intervals
        case blocker
        case sound
    }

    init() {}

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        time = try container.decode(Duration.self, forKey: .time)
        intervals = try container.decode(IntervalsSettings.self, forKey: .intervals)
        blocker = try container.decode(BlockerSettings.self, forKey: .blocker)
        sound = try container.decode(SoundSettings.self, forKey: .sound)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(time, forKey: .time)
        try container.encode(intervals, forKey: .intervals)
        try container.encode(blocker, forKey: .blocker)
        try container.encode(sound, forKey: .sound)
    }
}

struct SoundSettings: Codable {
    var alertBeforeWork: Bool = true
    var alertBeforeRest: Bool = true
}

struct BlockerSettings: Codable {
    var isOn: Bool = false
    var applicationTokens: Set<ApplicationToken> = .init()
    var categoryTokens: Set<ActivityCategoryToken> = []
    var domainTokens: Set<WebDomainToken> = []

    var selectedCount: Int {
        applicationTokens.count + categoryTokens.count + domainTokens.count
    }
}

struct IntervalsSettings: Codable {
    var isOn: Bool = true
    var busy: Interval = .init(.minutes(25), autostart: true)
    var rest: Interval = .init(.minutes(5), autostart: true)
    var longRest: Interval = .init(.minutes(15), autostart: true)

    var total: Duration {
        busy.duration + rest.duration + longRest.duration
    }
}

struct Interval: Codable {
    var duration: Duration
    var autostart: Bool

    init(_ duration: Duration, autostart: Bool = true) {
        self.duration = duration
        self.autostart = autostart
    }

    var minutes: Int {
        Int(duration.minutes)
    }

    var seconds: Int {
        Int(duration.seconds)
    }
}

extension Duration {
    static func minutes(_ minutes: Int) -> Duration {
        .seconds(minutes * 60)
    }

    var minutes: Int {
        Int(components.seconds) / 60
    }

    var seconds: Int {
        Int(components.seconds) % 60
    }
}

extension Duration {
    var hr: String {
        minutes >= 60
            ? "\(minutes / 60)h \(minutes % 60)m"
            : "\(minutes % 60)m"

    }
}
