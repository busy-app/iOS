import AVFoundation

class TickTock {
    var volume: Float = 0

    var player: AVAudioPlayer? = {
        do {
            guard let url = Bundle.main.url(
                forResource: "tick",
                withExtension:"mp3"
            ) else {
                return nil
            }
            try AVAudioSession
                .sharedInstance()
                .setCategory(.playback, options: .mixWithOthers)
            try AVAudioSession.sharedInstance().setActive(true)
            return try AVAudioPlayer(contentsOf: url)
        } catch {
            return nil
        }
    }()

    func play() {
        guard let player else { return }
        player.volume = volume
        player.play()
    }
}
