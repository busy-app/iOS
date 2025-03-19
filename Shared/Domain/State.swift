import Foundation

public enum AppState {
    case cards
    case busy
}

public enum TimerState: Codable, Sendable {
    case paused
    case running
    case finished
}

public enum IntervalKind: Codable, Sendable {
    case work
    case rest
    case longRest
}

public enum IntervalSequence: Codable, Sendable {
    case infinite(Int)
    case finite(current: Int, total: Int)
}

public struct IntervalState: Codable, Hashable, Sendable {
    var state: TimerState
    var time: ClosedRange<Date>
    var kind: IntervalKind

    init(
        state: TimerState,
        time: ClosedRange<Date>,
        kind: IntervalKind
    ) {
        self.state = state
        self.time = time
        self.kind = kind
    }
}
