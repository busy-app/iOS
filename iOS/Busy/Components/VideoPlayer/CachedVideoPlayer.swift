import AVKit

class CachedVideoPlayer {
    var player: AVQueuePlayer
    var playerLooper: AVPlayerLooper

    @MainActor static let fire: CachedVideoPlayer = { .init("Fire.mp4") }()
    @MainActor static let smoke: CachedVideoPlayer = { .init("Smoke.mp4") }()

    @MainActor static func touch() {
        _ = fire
        _ = smoke
    }

    convenience init(_ name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: nil) else {
            fatalError("Can't find \(name) in app bundle")
        }
        self.init(with: .init(fileURLWithPath: path))
    }

    init(with url: URL) {
        let item = AVPlayerItem(asset: AVURLAsset(url: url))
        self.player = AVQueuePlayer(playerItem: item)
        self.player.allowsExternalPlayback = false
        self.playerLooper = AVPlayerLooper(player: player, templateItem: item)
    }
}
