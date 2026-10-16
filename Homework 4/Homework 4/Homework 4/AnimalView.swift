import SwiftUI
import AVFoundation

struct AnimalView: View {
    let name: String

    @State private var player: AVAudioPlayer?

    var body: some View {
        VStack(spacing: 20) {
            Image(name)
                .resizable()
                .scaledToFit()
                .frame(width: 300, height: 300)
                .onTapGesture {
                    playSound()
                }

            Text("Tap the \(name)!")
                .font(.title2)
        }
        .navigationTitle(name.capitalized)
    }

    func playSound() {
        if let url = Bundle.main.url(forResource: name, withExtension: "mp3") {
            player = try? AVAudioPlayer(contentsOf: url)
            player?.play()
        } else {
            print("Could not find \(name).mp3")
        }
    }
}

#Preview {
    NavigationStack {
        AnimalView(name: "cat")
    }
}
