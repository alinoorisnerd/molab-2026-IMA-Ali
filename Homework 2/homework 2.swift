import Foundation
import Playgrounds

func load(_ name: String) -> [String] {
    let folder = URL(fileURLWithPath: #filePath).deletingLastPathComponent().appendingPathComponent("ascii_images")
    let bundlePath = Bundle.main.path(forResource: name, ofType: "txt") ?? ""
    let text = (try? String(contentsOf: folder.appendingPathComponent(name + ".txt"), encoding: .utf8))
        ?? (try? String(contentsOfFile: bundlePath, encoding: .utf8)) ?? ""
    var lines = text.replacingOccurrences(of: "\r", with: "").components(separatedBy: "\n")
    if lines.last == "" {
        lines.removeLast()
    }
    return lines
}

func widest(_ lines: [String]) -> Int {
    return lines.map { $0.count }.max() ?? 0
}

func frame(_ art: [String], checkered: Bool) -> [String] {
    let width = widest(art) + 4
    let height = art.count + 2
    func edge(_ row: Int, _ col: Int) -> String {
        return checkered && (row + col) % 2 == 1 ? "." : "#"
    }
    var result: [String] = []
    for row in 0..<height {
        if row == 0 || row == height - 1 {
            var line = ""
            for col in 0..<width {
                line += edge(row, col)
            }
            result.append(line)
        } else {
            let line = art[row - 1]
            let padding = String(repeating: " ", count: width - 4 - line.count)
            result.append(edge(row, 0) + " " + line + padding + " " + edge(row, width - 1))
        }
    }
    return result
}

func addPyramid(_ art: [String]) -> [String] {
    let width = widest(art)
    let height = max(1, min(art.count / 2, (width + 1) / 2))
    var result: [String] = []
    for row in 1...height {
        let spaces = String(repeating: " ", count: (width - (height * 2 - 1)) / 2 + height - row)
        result.append(spaces + String(repeating: "^", count: row * 2 - 1))
    }
    return result + art
}

#Playground {
    let cr7 = load("cr7")
    let divider = "\n---------------\n"

    print("cr7.txt has \(cr7.count) lines")
    print(divider)
    print("CR7 on a checkerboard with a pyramid on top")
    print(addPyramid(frame(cr7, checkered: true)).joined(separator: "\n"))
    print(divider)
    print("CR7 inside a frame")
    print(frame(cr7, checkered: false).joined(separator: "\n"))
}
