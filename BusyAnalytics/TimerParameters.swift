import Foundation

public struct TimerParameters {
    public let isIntervalsEnabled: Bool
    public let totalTime: Duration
    public let workTimer: Duration
    public let restTime: Duration
    public let longRestTime: Duration
    public let isMetronomeEnabled: Bool
    public let isMusicEnabled: Bool
    public let isBlockingEnabled: Bool
    public let isAllAppBlocking: Bool

    public init(
        isIntervalsEnabled: Bool,
        totalTime: Duration,
        workTimer: Duration,
        restTime: Duration,
        longRestTime: Duration,
        isMetronomeEnabled: Bool,
        isMusicEnabled: Bool,
        isBlockingEnabled: Bool,
        isAllAppBlocking: Bool
    ) {
        self.isIntervalsEnabled = isIntervalsEnabled
        self.totalTime = totalTime
        self.workTimer = workTimer
        self.restTime = restTime
        self.longRestTime = longRestTime
        self.isMetronomeEnabled = isMetronomeEnabled
        self.isMusicEnabled = isMusicEnabled
        self.isBlockingEnabled = isBlockingEnabled
        self.isAllAppBlocking = isAllAppBlocking
    }

    func collect() -> [String: String] {
        [
            "intervals_enabled": "\(isIntervalsEnabled)",
            "total_time": "\(totalTime.ms)",
            "work_timer": "\(workTimer.ms)",
            "rest_time": "\(restTime.ms)",
            "long_rest_time": "\(restTime.ms)",
            "audio_enabled": "\(isMetronomeEnabled)",
            "music_enabled": "\(isMusicEnabled)",
            "blocking_enabled": "\(isBlockingEnabled)",
            "all_app_blocking": "\(isAllAppBlocking)",
        ]
    }
}
