import Foundation
import Observation

@MainActor
@Observable
class Timer {
    private(set) var timeLeft: Duration = .seconds(0)

    @ObservationIgnored var completion: (() -> Void)?

    @ObservationIgnored private var deadline: Date = .now
    @ObservationIgnored private var timer: Foundation.Timer?

    init() {
    }

    deinit {
    }

    func start(_ duration: Duration) {
        precondition(timer == nil)
        timeLeft = duration
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
            block: { _ in
                Task { @MainActor [weak self] in
                    self?.update()
                }
            }
        )
    }

    func finish() {
        timer?.invalidate()
        completion?()
    }

    private func update() {
        timeLeft = .seconds(max(0, deadline.timeIntervalSinceNow.rounded(.up)))
        if timeLeft <= .seconds(0) {
            finish()
        }
    }
}
