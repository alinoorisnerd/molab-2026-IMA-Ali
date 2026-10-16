import Foundation
import Playgrounds

// I couldn't think of much. Therefore decided to settle with the classic shapes, and of course the checkerboard! However, It would be great if these shapes can be customized with symbols and size of choice!

func drawSquare(size: Int, symbol: String) {
    for _ in 1...size {
        print(String(repeating: symbol, count: size))
    }
}

func drawHollowSquare(size: Int, symbol: String) {
    for row in 1...size {
        if row == 1 || row == size {
            print(String(repeating: symbol, count: size))
        } else {
            print(symbol + String(repeating: " ", count: size - 2) + symbol)
        }
    }
}

func drawPyramid(height: Int, symbol: String) {
    for row in 1...height {
        let spaces = String(repeating: " ", count: height - row)
        let blocks = String(repeating: symbol, count: row * 2 - 1)
        print(spaces + blocks)
    }
}

func drawDiamond(size: Int, symbol: String) {
    drawPyramid(height: size, symbol: symbol)
    for row in (1..<size).reversed() {
        let spaces = String(repeating: " ", count: size - row)
        let blocks = String(repeating: symbol, count: row * 2 - 1)
        print(spaces + blocks)
    }
}

func drawCheckerboard(size: Int) {
    for row in 0..<size {
        var line = ""
        for col in 0..<size {
            if (row + col) % 2 == 0 {
                //playing with odd and even here.
                line += "#"
            } else {
                line += "."
            }
        }
        print(line)
    }
}

func drawDivider() {
    print("")
    print(String(repeating: "-", count: 15))
    print("")
}

#Playground {
    drawSquare(size: 4, symbol: "*")
    drawDivider()
    drawHollowSquare(size: 6, symbol: "#")
    drawDivider()
    drawPyramid(height: 5, symbol: "^")
    drawDivider()
    drawDiamond(size: 5, symbol: "o")
    drawDivider()
    drawCheckerboard(size: 8)
}
