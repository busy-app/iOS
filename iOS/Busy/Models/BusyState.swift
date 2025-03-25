import Foundation
import Observation

@MainActor
@Observable
class BusyState {
    let settings: BusySettings

    var intervals: Intervals

    var state: TimerState
    var interval: Interval?

    var startTime: Date?

    private var ticker: Ticker?

    private var isStopwatch: Bool {
        interval?.isInfinite ?? false
    }

    private var isInfinite: Bool {
        settings.intervals.isOn && settings.duration == .infinity
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

        mutating func next(loop: Bool) -> Interval? {
            guard index + 1 < intervals.count else {
                guard loop else {
                    return nil
                }
                index = 0
                return intervals[index]
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

        var remaining: Duration {
            isInfinite ? .seconds(0) : duration - elapsed
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

        startTime = Date.now
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
        interval = intervals.next(loop: isInfinite)
    }
}

extension BusyState.Intervals {
    var technique: [IntervalKind] {
        [.work, .rest, .work, .rest, .work, .longRest]
    }

    // TODO: you know what
    init(settings: BusySettings) {
        // MARK: No intervals

        guard settings.intervals.isOn else {
            self.intervals = [
                .init(
                    kind: .work,
                    duration: settings.duration
                )
            ]
            return
        }

        // MARK: Infinite intervals

        func duration(for kind: IntervalKind) -> Duration {
            switch kind {
            case .work: settings.intervals.busy.duration
            case .rest: settings.intervals.rest.duration
            case .longRest: settings.intervals.longRest.duration
            }
        }

        guard settings.duration > .seconds(0) else {
            for kind in technique {
                let duration = duration(for: kind)
                self.intervals.append(.init(kind: kind, duration: duration))
            }
            return
        }

        // MARK: Finite intervals

        var timeLeft = settings.duration
        var intervals = [BusyState.Interval]()

        func add(_ kind: IntervalKind) {
            let duration = duration(for: kind)
            intervals.append(.init(kind: kind, duration: duration))
            timeLeft = .seconds(timeLeft.seconds - duration.seconds)
        }

        while timeLeft > .seconds(0) {
            for kind in technique {
                if timeLeft > .seconds(0) {
                    add(kind)
                }
            }
        }

        self.intervals = intervals
    }
}

extension BusyState {
    static var preview: BusyState {
        .init(.init())
    }
}

extension BusyState {
    class Holder {
        @MainActor static let shared = Holder()

        private(set) var current: BusyState?

        func set(_ state: BusyState) {
            self.current = state
        }
    }
}
