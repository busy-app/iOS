import Foundation
import Observation

@Observable
class Timer {
    typealias SystemTimer = Foundation.Timer

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

    @ObservationIgnored private var deadline: Date = .now
    @ObservationIgnored private var timer: SystemTimer = .init()
    @ObservationIgnored private var onEnd: (() -> Void)?

    func start(minutes: Int, seconds: Int, onEnd: @escaping () -> Void) {
        stop()
        self.minutes = minutes
        self.seconds = seconds
        self.onEnd = onEnd
        resume()
    }

    func pause() {
        state = .paused
        timer.invalidate()
    }

    func stop() {
        state = .stopped
        timer.invalidate()
    }

    func resume() {
        state = .running
        deadline = .now.addingTimeInterval(.init(timeInterval))
        timer = SystemTimer.scheduledTimer(
            withTimeInterval: 0.2,
            repeats: true,
            block: update
        )
    }

    private func update(_: SystemTimer? = nil) {
        guard deadline > .now else {
            stop()
            onEnd?()
            return
        }
        timeInterval = .init(deadline.timeIntervalSinceNow)
    }

    func increase() {
        deadline.addTimeInterval(5)
        update()
    }

    func decrease() {
        deadline.addTimeInterval(-5)
        update()
    }
}
