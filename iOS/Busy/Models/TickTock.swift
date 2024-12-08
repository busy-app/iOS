import AVFoundation

class TickTock {
    private let soundId: SystemSoundID

    private let url: URL = {
        Bundle.main.url(
            forResource: "silence",
            withExtension:"mp3"
        )!
    }()

    init() {
        var soundId: SystemSoundID = 0
        AudioServicesCreateSystemSoundID(url as NSURL, &soundId)
        self.soundId = soundId
    }

    func play() {
        AudioServicesPlaySystemSound(soundId)
    }
}
