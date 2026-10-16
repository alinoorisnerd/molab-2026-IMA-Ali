import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack(spacing: 30) {
                NavigationLink("🐱 Cat") {
                    AnimalView(name: "cat")
                }

                NavigationLink("🐶 Dog") {
                    AnimalView(name: "dog")
                }

                NavigationLink("🐸 Frog") {
                    AnimalView(name: "frog")
                }
            }
            .font(.largeTitle)
            .navigationTitle("Animals")
        }
    }
}

#Preview {
    ContentView()
}
