import SwiftUI

struct ContentView: View {
    let ballArray = ["ball4", "ball1", "ball1", "ball4", "ball2"]

    private let defaults = UserDefaults.standard
    private let lastIndexKey = "lastBallIndex"
    private let lastDateKey = "lastBallDate"
    private let reuseWindow: TimeInterval = 120

    @State private var currentIndex = 0

    var body: some View {
        ZStack {
            Color.indigo
                .ignoresSafeArea()

            VStack(spacing: 16) {
                Text("Ask Me Anything")
                    .font(.system(size: 28))
                    .foregroundStyle(Color(white: 0.95))
                    .padding(.top, 60)

                Spacer()

                Image(ballArray[currentIndex])
                    .resizable()
                    .scaledToFit()
                    .frame(height: 302)
                    .padding(.horizontal, 13)

                Spacer()

                Button("Press ME") {
                    runSuggestion()
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.white.opacity(0.6))
                .foregroundStyle(.black)

                Text("or")
                    .font(.system(size: 30))
                    .foregroundStyle(.white)

                Text(" Shake ")
                    .font(.system(size: 30))
                    .foregroundStyle(.white)
                    .padding(.bottom, 40)
            }
        }
        .onShake {
            if let savedIndex = recentSavedIndex() {
                show(savedIndex)
            } else {
                runSuggestion()
            }
        }
    }

    func runSuggestion() {
        let index = Int.random(in: 0..<ballArray.count)
        show(index)
        saveResult(index)
    }

    func show(_ index: Int) {
        currentIndex = index
    }

    func saveResult(_ index: Int) {
        defaults.set(index, forKey: lastIndexKey)
        defaults.set(Date(), forKey: lastDateKey)
    }

    func recentSavedIndex() -> Int? {
        guard let savedDate = defaults.object(forKey: lastDateKey) as? Date,
              Date().timeIntervalSince(savedDate) < reuseWindow,
              defaults.object(forKey: lastIndexKey) != nil else {
            return nil
        }
        let index = defaults.integer(forKey: lastIndexKey)
        return ballArray.indices.contains(index) ? index : nil
    }
}

#Preview {
    ContentView()
}
