struct TimerSettings: Codable, RawRepresentable {
    var isOn: Bool = false
    var minute: Int = 15
    var second: Int = 0

    var isValid: Bool {
        return minute > 0 || second >= 0 && second < 60
    }

    enum CodingKeys: CodingKey {
        case isOn
        case minute
        case second
    }

    init() {}

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isOn = try container.decode(Bool.self, forKey: .isOn)
        minute = try container.decode(Int.self, forKey: .minute)
        second = try container.decode(Int.self, forKey: .second)
    }

    func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isOn, forKey: .isOn)
        try container.encode(minute, forKey: .minute)
        try container.encode(second, forKey: .second)
    }
}
