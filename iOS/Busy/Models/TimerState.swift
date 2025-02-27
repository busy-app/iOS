struct TimerState: Codable, RawRepresentable {
    var minutes: Int = 15
    var seconds: Int = 0

    var isValid: Bool {
        return minutes > 0 || seconds >= 0 && seconds < 60
    }
}
