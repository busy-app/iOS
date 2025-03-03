import Foundation
import Observation

@MainActor
@Observable
class Timer {
    enum State {
        case finished
        case running
        case paused
    }

    private(set) var state: State = .paused
    private(set) var timeLeft: Duration = .seconds(0)

    @ObservationIgnored var completion: (() -> Void)?

    @ObservationIgnored private var deadline: Date = .now
    @ObservationIgnored private var timer: Foundation.Timer?

    init() {
    }

    deinit {
    }

    func start(_ duration: Duration) {
        precondition(state != .running)
        timeLeft = duration
        resume()
    }

    func pause() {
        timer?.invalidate()
        state = .paused
    }

    func resume() {
        state = .running
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
        state = .finished
        completion?()
    }

    private func update() {
        timeLeft = .seconds(max(0, deadline.timeIntervalSinceNow.rounded(.up)))
        if timeLeft <= .seconds(0) {
            finish()
        }
    }
}
