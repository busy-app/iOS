import Foundation
import Observation

class Timer: Ticker, @unchecked Sendable {
    var callback: Callback

    var timeLeft: Duration

    private var deadline: Date = .now
    private var timer: Foundation.Timer?

    init(
        duration: Duration = .seconds(1),
        callback: @escaping Callback
    ) {
        self.timeLeft = duration
        self.callback = callback
    }

    deinit {
        print("Timer.deinit")
    }

    func start() {
        precondition(timer == nil)
        resume()
    }

    func pause() {
        timer?.invalidate()
    }

    func resume() {
        deadline = .now.addingTimeInterval(.init(timeLeft.seconds))
        timer = .scheduledTimer(
            withTimeInterval: 1,
            repeats: true,
            block: { [weak self] _ in
                guard let self else { return }
                self.update()
            }
        )
    }

    private func update() {
        timeLeft = .seconds(max(0, deadline.timeIntervalSinceNow.rounded(.up)))
        if timeLeft <= .seconds(0) {
            timer?.invalidate()
        }
        callback(timeLeft)
    }
}
