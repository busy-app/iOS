import ManagedSettings
import FamilyControls
import Foundation

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

struct BlockerSettings {
    #if os(iOS)
    var applicationTokens: Set<ApplicationToken> = []
    var categoryTokens: Set<ActivityCategoryToken> = []
    var domainTokens: Set<WebDomainToken> = []
    #else
    var applicationTokens: Set<Data> = []
    var categoryTokens: Set<Data> = []
    var domainTokens: Set<Data> = []
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

// MARK: Codable

extension BlockerSettings: Codable {

    enum CodingKeys: String, CodingKey {
        case applicationTokens
        case categoryTokens
        case domainTokens
    }

    static func decode<T: Codable>(
        _ container: KeyedDecodingContainer<CodingKeys>,
        key: CodingKeys,
    ) throws -> Set<T> {
        #if os(iOS)
        let data = try container.decode([Data].self, forKey: key)
        return Set(data.compactMap {
            try? JSONDecoder().decode(T.self, from: $0)
        })
        #else
        return Set(try container.decode([T].self, forKey: key))
        #endif
    }

    static func encode<T: Codable>(
        _ container: inout KeyedEncodingContainer<CodingKeys>,
        _ set: Set<T>,
        key: CodingKeys
    ) throws {
        #if os(iOS)
        let data = try set.map { try JSONEncoder().encode($0) }
        #else
        let data = Array(set)
        #endif
        try container.encode(data, forKey: key)
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        applicationTokens = try BlockerSettings.decode(
            container,
            key: .applicationTokens
        )

        categoryTokens = try BlockerSettings.decode(
            container,
            key: .categoryTokens
        )

        domainTokens = try BlockerSettings.decode(
            container,
            key: .domainTokens
        )
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try BlockerSettings.encode(
            &container,
            applicationTokens,
            key: .applicationTokens
        )

        try BlockerSettings.encode(
            &container,
            categoryTokens,
            key: .categoryTokens
        )

        try BlockerSettings.encode(
            &container,
            domainTokens,
            key: .domainTokens
        )
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
