import Foundation
import Observation

import ActivityKit

@Observable
class Timer {
    typealias SystemTimer = Foundation.Timer

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

    @ObservationIgnored private let tickTock = TickTock()
    @ObservationIgnored private var activity: Activity<BusyWidgetAttributes>?

    @ObservationIgnored private var deadline: Date = .now
    @ObservationIgnored private var timer: SystemTimer = .init()
    @ObservationIgnored private var onEnd: (() -> Void)?

    func start(
        minutes: Int,
        seconds: Int,
        metronome: Bool,
        onEnd: @escaping () -> Void
    ) {
        stop()
        self.minutes = minutes
        self.seconds = seconds
        self.tickTock.volume = metronome ? 1 : 0
        self.onEnd = onEnd
        resume()
    }

    func pause() {
        state = .paused
        timer.invalidate()
        stopActivity()
    }

    func stop() {
        state = .stopped
        timer.invalidate()
        stopActivity()
    }

    func resume() {
        state = .running
        deadline = .now.addingTimeInterval(.init(timeInterval))
        timer = SystemTimer.scheduledTimer(
            withTimeInterval: 1,
            repeats: true,
            block: update
        )
        startActivity()
    }

    private func update(_: SystemTimer) {
        update()
        tickTock.play()
    }

    private func update() {
        guard deadline > .now else {
            stop()
            onEnd?()
            return
        }
        timeInterval = .init(deadline.timeIntervalSinceNow.rounded(.up))
    }

    func increase() {
        deadline.addTimeInterval(5)
        update()
        updateActivity()
    }

    func decrease() {
        deadline.addTimeInterval(-5)
        update()
        updateActivity()
    }
}


extension Timer {
    var contentState: BusyWidgetAttributes.ContentState {
        .init(
            isOn: state == .running,
            deadline: deadline
        )
    }

    func startActivity() {
        activity = try? Activity<BusyWidgetAttributes>.request(
            attributes: .init(),
            content: .init(state: contentState, staleDate: deadline))
    }

    func updateActivity() {
        Task {
            await activity?.update(
                .init(
                    state: contentState,
                    staleDate: deadline
                )
            )
        }
    }

    func stopActivity() {
        Task {
            await activity?.end(.none, dismissalPolicy: .immediate)
            activity = nil
        }
    }
}
