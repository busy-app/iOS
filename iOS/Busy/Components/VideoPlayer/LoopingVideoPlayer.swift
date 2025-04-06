import AVKit
import SwiftUI

struct LoopingVideoPlayer: View {
    @Environment(\.scenePhase) var scenePhase

    let kind: IntervalKind

    init(_ kind: IntervalKind) {
        self.kind = kind
    }

    var opacity: Double {
        switch kind {
        case .work: 0.2
        case .rest, .longRest: 0.3
        }
    }

    func player(for kind: IntervalKind) -> AVQueuePlayer {
        switch kind {
        case .work: CachedVideoPlayer.fire.player
        case .rest, .longRest: CachedVideoPlayer.smoke.player
        }
    }

    var body: some View {
        VideoPlayer(player: player(for: kind))
            .opacity(opacity)
            .onAppear {
                player(for: kind).play()
            }
            .onDisappear {
                player(for: kind).pause()
            }
            .onChange(of: kind) { old, new in
                player(for: old).pause()
                player(for: new).play()
            }
            .onChange(of: scenePhase) {
                switch scenePhase {
                case .active: player(for: kind).play()
                default: break
                }
            }
    }
}

extension AVPlayerViewController {
    override open func viewDidLoad() {
        super.viewDidLoad()
        self.showsPlaybackControls = false
    }
}

#Preview {
    LoopingVideoPlayer(.rest)
        .disabled(true)
}
