import SwiftUI
import PhotosUI
import ImageIO
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var pickerItem: PhotosPickerItem?
    @State private var photo: CGImage?
    @State private var left = 0.0
    @State private var right = 0.0
    @State private var top = 0.0
    @State private var bottom = 0.0
    @State private var filterName = "None"

    private let filterNames = ["None", "Sepia", "Noir", "Chrome", "Blur"]
    private let context = CIContext()

    var croppedPhoto: CGImage? {
        guard let photo else { return nil }
        let width = CGFloat(photo.width)
        let height = CGFloat(photo.height)
        let area = CGRect(
            x: width * left,
            y: height * top,
            width: width * (1 - left - right),
            height: height * (1 - top - bottom)
        )
        return photo.cropping(to: area)
    }

    var finalPhoto: CGImage? {
        guard let croppedPhoto else { return nil }
        return applyFilter(croppedPhoto)
    }

    var body: some View {
        VStack(spacing: 16) {
            if let finalPhoto {
                Image(decorative: finalPhoto, scale: 1)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 350)
            } else {
                Text("No photo yet")
                    .frame(height: 350)
            }

            PhotosPicker("Choose Photo", selection: $pickerItem, matching: .images)
                .buttonStyle(.borderedProminent)

            if photo != nil {
                Picker("Filter", selection: $filterName) {
                    ForEach(filterNames, id: \.self) { name in
                        Text(name)
                    }
                }
                .pickerStyle(.segmented)

                HStack {
                    Text("Left").frame(width: 60, alignment: .leading)
                    Slider(value: $left, in: 0...0.45)
                }
                HStack {
                    Text("Right").frame(width: 60, alignment: .leading)
                    Slider(value: $right, in: 0...0.45)
                }
                HStack {
                    Text("Top").frame(width: 60, alignment: .leading)
                    Slider(value: $top, in: 0...0.45)
                }
                HStack {
                    Text("Bottom").frame(width: 60, alignment: .leading)
                    Slider(value: $bottom, in: 0...0.45)
                }

                HStack(spacing: 20) {
                    Button("Reset") {
                        left = 0
                        right = 0
                        top = 0
                        bottom = 0
                        filterName = "None"
                    }
                    .buttonStyle(.bordered)

                    if let finalPhoto {
                        let image = Image(decorative: finalPhoto, scale: 1)
                        ShareLink(item: image, preview: SharePreview("Edited photo", image: image)) {
                            Label("Save", systemImage: "square.and.arrow.down")
                        }
                        .buttonStyle(.borderedProminent)
                    }
                }
            }
        }
        .padding()
        .onChange(of: pickerItem) {
            loadPhoto()
        }
    }

    func applyFilter(_ image: CGImage) -> CGImage {
        let input = CIImage(cgImage: image)
        var output = input

        switch filterName {
        case "Sepia":
            let filter = CIFilter.sepiaTone()
            filter.inputImage = input
            filter.intensity = 1
            output = filter.outputImage ?? input
        case "Noir":
            let filter = CIFilter.photoEffectNoir()
            filter.inputImage = input
            output = filter.outputImage ?? input
        case "Chrome":
            let filter = CIFilter.photoEffectChrome()
            filter.inputImage = input
            output = filter.outputImage ?? input
        case "Blur":
            let filter = CIFilter.gaussianBlur()
            filter.inputImage = input
            filter.radius = 10
            output = filter.outputImage ?? input
        default:
            return image
        }

        return context.createCGImage(output, from: input.extent) ?? image
    }

    func loadPhoto() {
        Task {
            if let data = try? await pickerItem?.loadTransferable(type: Data.self),
               let source = CGImageSourceCreateWithData(data as CFData, nil) {
                let options: [CFString: Any] = [
                    kCGImageSourceCreateThumbnailFromImageAlways: true,
                    kCGImageSourceCreateThumbnailWithTransform: true,
                    kCGImageSourceThumbnailMaxPixelSize: 2000
                ]
                photo = CGImageSourceCreateThumbnailAtIndex(source, 0, options as CFDictionary)
                left = 0
                right = 0
                top = 0
                bottom = 0
                filterName = "None"
            }
        }
    }
}

#Preview {
    ContentView()
}
