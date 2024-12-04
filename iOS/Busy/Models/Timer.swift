import Observation

@Observable
class Timer {
    var state: State = .stopped

    var minutes: Int = 0
    var seconds: Int = 0

    enum State {
        case running
        case stopped
        case paused
    }

    private var timer: Task<Void, Swift.Error>?
    private var onEnd: (() -> Void)?

    func start(minutes: Int, seconds: Int, onEnd: @escaping () -> Void) {
        self.onEnd = onEnd
        if state != .stopped {
            stop()
        }
        self.minutes = minutes
        self.seconds = seconds
        resume()
    }

    func pause() {
        state = .paused
        timer?.cancel()
        timer = nil
    }

    func resume() {
        state = .running
        timer = Task {
            while minutes > 0 || seconds > 0 {
                try await Task.sleep(for: .seconds(1))
                if seconds > 0 {
                    seconds -= 1
                } else if minutes > 0 {
                    seconds = 59
                    minutes -= 1
                }
            }
            stop()
            onEnd?()
        }
    }

    func stop() {
        state = .stopped
        timer?.cancel()
        timer = nil
    }

    func increase() {
        seconds += 5

        if seconds >= 60 {
            if minutes < 99 {
                minutes += 1
                seconds = seconds % 60
            } else {
                seconds = 59
            }
        }
    }

    func decrease() {
        seconds -= 5

        if seconds < 0 {
            if minutes > 0 {
                minutes -= 1
                seconds += 60
            } else {
                seconds = 0
                stop()
            }
        }
    }
}
