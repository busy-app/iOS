import Foundation
import Observation

class Stopwatch: Ticker, @unchecked Sendable {
    var callback: Callback

    var time: Duration { elapsed + current }

    private var elapsed: Duration = .seconds(0)
    private var current: Duration = .seconds(0)

    private var started: Date = .now
    private var timer: Foundation.Timer?

    init(callback: @escaping Callback) {
        self.callback = callback
    }

    deinit {
        print("Stopwatch.deinit")
    }

    func start() {
        precondition(timer == nil)
        resume()
    }

    func pause() {
        timer?.invalidate()
        timer = nil
        elapsed += current
        current = .seconds(0)
    }

    func resume() {
        started = .now
        timer = .scheduledTimer(
            withTimeInterval: 0.1,
            repeats: true,
            block: { [weak self] _ in
                guard let self else { return }
                self.update()
            }
        )
    }

    private func update() {
        let elapsed = Date.now.timeIntervalSince(started).rounded(.up)

        if current != .seconds(elapsed) {
            current = .seconds(elapsed)
            callback(time)
        }
    }
}
