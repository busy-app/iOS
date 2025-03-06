import Foundation
import Observation

@MainActor
@Observable
class Timer {
    @MainActor
    static let shared = Timer()
    private init() {}

    private(set) var state: State = .stopped
    private(set) var minutes: Int = 0
    private(set) var seconds: Int = 0

    var timeInterval: Int {
        get {
            minutes * 60 + seconds
        }
        set {
            guard timeInterval != newValue else { return }
            minutes = min(59, max(0, newValue / 60))
            seconds = max(0, Int(newValue % 60))
        }
    }

    enum State {
        case running
        case stopped
        case paused
    }

    @ObservationIgnored var onChange: (() -> Void)?
    @ObservationIgnored var onEnd: (() -> Void)?

    @ObservationIgnored private(set) var deadline: Date = .now
    @ObservationIgnored private var timer: Foundation.Timer = .init()

    func start(
        minutes: Int,
        seconds: Int
    ) {
        stop()
        self.minutes = minutes
        self.seconds = seconds
        resume()
    }

    func pause() {
        state = .paused
        timer.invalidate()
        onChange?()
    }

    func stop() {
        state = .stopped
        timer.invalidate()
        onChange?()
    }

    func resume() {
        state = .running
        deadline = .now.addingTimeInterval(.init(timeInterval))
        timer = .scheduledTimer(
            withTimeInterval: 1,
            repeats: true,
            block: { _ in
                Task { @MainActor in
                    self.update()
                }
            }
        )
        onChange?()
    }

    private func update() {
        guard deadline > .now else {
            stop()
            onEnd?()
            return
        }
        timeInterval = .init(deadline.timeIntervalSinceNow.rounded(.up))
        onChange?()
    }
}
