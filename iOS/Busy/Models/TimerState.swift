struct TimerState: Codable, RawRepresentable {
    var minute: Int = 15
    var second: Int = 0

    var isValid: Bool {
        return minute > 0 || second >= 0 && second < 60
    }
}
