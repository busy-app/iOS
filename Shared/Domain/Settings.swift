import ManagedSettings
import FamilyControls

struct BusySettings: Codable, Equatable, RawRepresentable {
    var name: String = "BUSY"
    var duration: Duration = .minutes(120)
    var intervals: IntervalsSettings = .init()
    var blocker: BlockerSettings = .init()
    var sound: SoundSettings = .init()

    enum CodingKeys: CodingKey {
        case name
        case duration
        case intervals
        case blocker
        case sound
    }

    init() {}

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        name = try container.decode(String.self, forKey: .name)
        duration = try container.decode(Duration.self, forKey: .duration)
        intervals = try container.decode(IntervalsSettings.self, forKey: .intervals)
        blocker = try container.decode(BlockerSettings.self, forKey: .blocker)
        sound = try container.decode(SoundSettings.self, forKey: .sound)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(duration, forKey: .duration)
        try container.encode(intervals, forKey: .intervals)
        try container.encode(blocker, forKey: .blocker)
        try container.encode(sound, forKey: .sound)
    }
}

struct SoundSettings: Codable {
    var intervals: Bool = true
    var metronome: Bool = false
}

struct BlockerSettings: Codable {
    #if os(iOS)
    var applicationTokens: Set<ApplicationToken> = .init()
    var categoryTokens: Set<ActivityCategoryToken> = []
    var domainTokens: Set<WebDomainToken> = []
    #else
    var applicationTokens: Set<String> = []
    var categoryTokens: Set<String> = []
    var domainTokens: Set<String> = []

    init(from decoder: any Decoder) throws {
        self.applicationTokens = []
        self.categoryTokens = []
        self.domainTokens = []
    }
    #endif

    var selectedCount: Int {
        applicationTokens.count + categoryTokens.count + domainTokens.count
    }

    init() {
    }
}

struct IntervalsSettings: Codable {
    var isOn: Bool = true
    var busy: Interval = .init(.minutes(20), autostart: false)
    var rest: Interval = .init(.minutes(5), autostart: false)
    var longRest: Interval = .init(.minutes(15), autostart: false)
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

// MARK: Debug

extension BusySettings {
    mutating func setDebugIntervals() {
        self.duration = .seconds(30)

        self.intervals.busy.duration = .seconds(5)
        self.intervals.rest.duration = .seconds(5)
        self.intervals.longRest.duration = .seconds(5)
    }
}
