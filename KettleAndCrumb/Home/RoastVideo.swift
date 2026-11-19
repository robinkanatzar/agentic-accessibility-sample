import AVKit
import SwiftUI

struct RoastVideo: View {
    @State private var player: AVPlayer? = {
        guard let url = Bundle.main.url(forResource: "how_we_roast", withExtension: "mp4") else {
            return nil
        }
        return AVPlayer(url: url)
    }()

    var body: some View {
        VideoPlayer(player: player)
            .aspectRatio(16 / 9, contentMode: .fit)
            .clipShape(RoundedRectangle(cornerRadius: Theme.cornerRadius))
            .onDisappear {
                player?.pause()
            }
    }
}

#Preview {
    RoastVideo()
        .padding()
}
