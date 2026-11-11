import SwiftUI
import PhotosUI
import AVKit
import CoreImage

struct ContentView: View {
    @State private var pickerItem: PhotosPickerItem?
    @State private var videoURL: URL?
    @State private var player = AVPlayer()

    @State private var filter = "None"
    @State private var squareCrop = false
    @State private var message = ""

    let filters = ["None", "Noir", "Mono", "Chrome", "Fade", "Instant", "Sepia"]

    var body: some View {
        VStack(spacing: 20) {
            PhotosPicker("Choose Video", selection: $pickerItem, matching: .videos)
                .buttonStyle(.borderedProminent)

            VideoPlayer(player: player)
                .frame(height: 350)

            Picker("Filter", selection: $filter) {
                ForEach(filters, id: \.self) { Text($0) }
            }
            Toggle("Square Crop", isOn: $squareCrop)

            Button("Save to Photos") {
                Task { await save() }
            }
            .buttonStyle(.bordered)
            .disabled(videoURL == nil)

            Text(message)
        }
        .padding()
        .onChange(of: pickerItem) { Task { await loadVideo() } }
        .onChange(of: filter) { updatePreview() }
        .onChange(of: squareCrop) { updatePreview() }
    }

    func loadVideo() async {
        guard let data = try? await pickerItem?.loadTransferable(type: Data.self) else { return }
        let url = FileManager.default.temporaryDirectory.appendingPathComponent("input.mov")
        try? data.write(to: url)
        videoURL = url
        updatePreview()
    }

    func updatePreview() {
        guard let url = videoURL else { return }
        let item = AVPlayerItem(url: url)
        item.videoComposition = makeComposition(asset: item.asset, filter: filter, square: squareCrop)
        player.replaceCurrentItem(with: item)
        player.play()
    }

    func save() async {
        guard let url = videoURL else { return }
        message = "Saving..."

        let asset = AVURLAsset(url: url)
        let session = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)!
        session.videoComposition = makeComposition(asset: asset, filter: filter, square: squareCrop)

        let output = FileManager.default.temporaryDirectory.appendingPathComponent("\(UUID()).mov")
        do {
            try await session.export(to: output, as: .mov)
            UISaveVideoAtPathToSavedPhotosAlbum(output.path, nil, nil, nil)
            message = "Saved to Photos!"
        } catch {
            message = "Error: \(error.localizedDescription)"
        }
    }
}

nonisolated func makeComposition(asset: AVAsset, filter: String, square: Bool) -> AVVideoComposition {
    let composition = AVMutableVideoComposition(asset: asset) { request in
        var image = request.sourceImage

        if filter == "Sepia" {
            image = image.applyingFilter("CISepiaTone")
        } else if filter != "None" {
            image = image.applyingFilter("CIPhotoEffect" + filter)
        }

        if square {
            let size = request.sourceImage.extent.size
            let side = floor(min(size.width, size.height) / 2) * 2
            let rect = CGRect(x: floor((size.width - side) / 2),
                              y: floor((size.height - side) / 2),
                              width: side, height: side)
            image = image.cropped(to: rect)
                .transformed(by: CGAffineTransform(translationX: -rect.minX, y: -rect.minY))
        }

        request.finish(with: image, context: nil)
    }

    if square {
        let side = floor(min(composition.renderSize.width, composition.renderSize.height) / 2) * 2
        composition.renderSize = CGSize(width: side, height: side)
    }
    return composition
}

#Preview {
    ContentView()
}
