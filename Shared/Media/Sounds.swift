import AVFoundation

class Sounds: @unchecked Sendable {
    static let shared = try! Sounds()

    var workCountdownPlayer: AVAudioPlayer?
    var workFinishedPlayer: AVAudioPlayer?
    var restCountdownPlayer: AVAudioPlayer?
    var restFinishedPlayer: AVAudioPlayer?
    var metronomePlayer: AVAudioPlayer?

    enum Kind {
        case workCountdown
        case workFinished
        case restCountdown
        case restFinished
        case metronome
    }

    private init() throws {
        workCountdownPlayer = try .init("work_countdown")
        workFinishedPlayer = try .init("work_finished")
        restCountdownPlayer = try .init("rest_countdown")
        restFinishedPlayer = try .init("rest_finished")
        metronomePlayer = try .init("tick")
    }

    func play(_ kind: Kind) {
        let player = switch kind {
        case .workCountdown: workCountdownPlayer
        case .workFinished: workFinishedPlayer
        case .restCountdown: restCountdownPlayer
        case .restFinished: restFinishedPlayer
        case .metronome: metronomePlayer
        }
        player?.play()
    }
}

extension AVAudioPlayer {
    convenience init(_ name: String, onType type: String = "mp3") throws {
        guard let path = Bundle.main.path(
            forResource: name,
            ofType: type
        ) else {
            throw URLError(.fileDoesNotExist)
        }

        try self.init(contentsOf: URL(fileURLWithPath: path))
    }
}
