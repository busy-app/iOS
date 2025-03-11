import Observation

@MainActor
@Observable
class BusyState {
    let settings: BusySettings

    var timer: Timer
    var intervals: Intervals

    var state: TimerState
    var interval: Interval?

    private var autostart: Bool {
        return switch interval?.kind {
        case .work: settings.intervals.busy.autostart
        case .rest: settings.intervals.rest.autostart
        case .longRest: settings.intervals.longRest.autostart
        default: false
        }
    }

    struct Intervals {
        var index: Int = 0
        var intervals: [Interval] = []

        init(_ intervals: [Interval]) {
            self.intervals = intervals.count > 0
                ? intervals
                : [.init(kind: .work, duration: .seconds(0))]
        }

        mutating func next() -> Interval? {
            guard index + 1 < intervals.count else {
                return nil
            }
            index += 1
            return intervals[index]
        }
    }

    struct Interval: Equatable {
        let kind: IntervalKind
        let duration: Duration
    }

    init(_ settings: BusySettings) {
        self.settings = settings

        self.timer = Timer()
        self.state = .paused

        self.intervals = Intervals(settings: settings)
        self.interval = intervals.intervals.first
    }

    func start() {
        guard let interval, state != .running else {
            print("something went wrong")
            return
        }
        timer.completion = { [weak self] in
            guard let self else { return }
            if autostart {
                next()
                start()
            }
        }
        timer.start(interval.duration)
    }

    func skip() {
        stop()
        next()
        start()
    }

    func stop() {
        state = .finished
        timer.finish()
        timer.completion = nil
    }

    func resume() {
        state = .running
        timer.resume()
    }

    func pause() {
        state = .paused
        timer.pause()
    }

    func next() {
        interval = intervals.next()
    }
}

extension BusyState.Intervals {
    init(settings: BusySettings) {
        guard settings.intervals.isOn else {
            self.intervals = [
                .init(
                    kind: .work,
                    duration: settings.duration
                )
            ]
            return
        }

        var timeLeft = settings.duration
        var intervals = [BusyState.Interval]()

        func add(_ kind: IntervalKind) {
            let duration = switch kind {
            case .work: settings.intervals.busy.duration
            case .rest: settings.intervals.rest.duration
            case .longRest: settings.intervals.longRest.duration
            }
            intervals.append(.init(kind: kind, duration: duration))
            timeLeft = .seconds(timeLeft.seconds - duration.seconds)
        }

        // <(^_^)>
        while timeLeft > .seconds(0) {
            if timeLeft > .seconds(0) { add(.work) }
            if timeLeft > .seconds(0) { add(.rest) }
            if timeLeft > .seconds(0) { add(.work) }
            if timeLeft > .seconds(0) { add(.rest) }
            if timeLeft > .seconds(0) { add(.work) }
            if timeLeft > .seconds(0) { add(.longRest) }
        }

        self.intervals = intervals
    }
}

extension BusyState {
    static var preview: BusyState {
        .init(.init())
    }
}
