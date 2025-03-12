import Observation

@MainActor
@Observable
class BusyState {
    let settings: BusySettings

    var intervals: Intervals

    var state: TimerState
    var interval: Interval?

    private var ticker: Ticker?

    private var isStopwatch: Bool {
        interval?.isInfinite ?? false
    }

    private var autostart: Bool {
        guard settings.intervals.isOn else { return false }
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
        var elapsed: Duration

        var isInfinite: Bool {
            duration == .zero
        }

        init(
            kind: IntervalKind,
            duration: Duration,
            elapsed: Duration = .seconds(0)
        ) {
            self.kind = kind
            self.duration = duration
            self.elapsed = elapsed
        }
    }

    init(_ settings: BusySettings) {
        self.settings = settings

        self.state = .paused

        self.intervals = Intervals(settings: settings)
        self.interval = intervals.intervals.first
    }

    let tickTock = TickTock()

    func start() {
        guard state != .running else {
            print("something went wrong")
            return
        }

        ticker = Stopwatch { [weak self] in
            guard let self else { return }
            self.onTick($0)
        }

        state = .running
        ticker?.start()
    }

    func onTick(_ elapsed: Duration) {
        interval?.elapsed = elapsed
        tickTock.play()

        guard let interval, !interval.isInfinite else { return }

        if interval.duration - interval.elapsed <= .seconds(0) {
            stop()
            if autostart {
                next()
                start()
            }
        }
    }

    func skip() {
        guard !isStopwatch else {
            print("something went wrong, stopwatch is not supported")
            return
        }
        stop()
        next()
        start()
    }

    func stop() {
        state = .finished
        ticker?.pause()
    }

    func resume() {
        state = .running
        ticker?.resume()
    }

    func pause() {
        state = .paused
        ticker?.pause()
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
