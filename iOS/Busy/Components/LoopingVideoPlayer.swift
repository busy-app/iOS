import AVKit
import SwiftUI

struct LoopingVideoPlayer: View {
    let url: URL?

    @State private var player: AVQueuePlayer?
    @State private var playerLooper: AVPlayerLooper?

    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        VideoPlayer(player: player)
            .onAppear {
                guard let url else { return }
                createPlayer(with: url)
                player?.play()
            }
            .onDisappear {
                player?.pause()
            }
            .onChange(of: scenePhase) {
                switch scenePhase {
                case .active: player?.play()
                default: break
                }
            }
    }

    func createPlayer(with url: URL) {
        let item = AVPlayerItem(asset: AVURLAsset(url: url))
        self.player = AVQueuePlayer(playerItem: item)
        self.player?.allowsExternalPlayback = false
        self.playerLooper = AVPlayerLooper(player: player!, templateItem: item)
    }

    init(_ name: String) {
        guard let path = Bundle.main.path(forResource: name, ofType: nil) else {
            print("Can't find \(name) in app bundle")
            self.url = nil
            return
        }
        self.url = .init(fileURLWithPath: path)
    }
}

extension AVPlayerViewController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.showsPlaybackControls = false
    }
}

#Preview {
    LoopingVideoPlayer("Smoke.mp4")
        .disabled(true)
}
