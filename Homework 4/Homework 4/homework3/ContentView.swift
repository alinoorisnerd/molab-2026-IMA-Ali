import SwiftUI

struct PitchBackground: View {
    var body: some View {
        Color(red: 0.05, green: 0.35, blue: 0.2)
            .ignoresSafeArea()
    }
}

struct BigTitle: View {
    var text: String

    var body: some View {
        Text(text)
            .font(.system(size: 44, weight: .black, design: .rounded))
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
    }
}

struct BigButtonLabel: View {
    var text: String

    var body: some View {
        Text(text)
            .font(.title2.bold())
            .foregroundStyle(.white)
            .padding(.vertical, 16)
            .frame(maxWidth: .infinity)
            .background(Color(red: 0.8, green: 0.1, blue: 0.15))
            .clipShape(Capsule())
    }
}

struct IntroView: View {
    var body: some View {
        ZStack {
            PitchBackground()
            VStack(spacing: 24) {
                Spacer()
                Image(systemName: "soccerball")
                    .font(.system(size: 100))
                    .foregroundStyle(.white)
                BigTitle(text: "Welcome to the Suiii App")
                Text("Tap the button to see the most famous celebration in football.")
                    .font(.title3)
                    .foregroundStyle(.white.opacity(0.8))
                    .multilineTextAlignment(.center)
                Spacer()
                NavigationLink {
                    SuiiiView()
                } label: {
                    BigButtonLabel(text: "Let's go")
                }
            }
            .padding(32)
        }
    }
}

struct SuiiiView: View {
    @State private var jumped = false

    var body: some View {
        ZStack {
            PitchBackground()
            VStack(spacing: 24) {
                Spacer()
                Image(systemName: jumped ? "figure.arms.open" : "figure.soccer")
                    .font(.system(size: 140))
                    .foregroundStyle(.white)
                    .offset(y: jumped ? -60 : 0)
                    .rotationEffect(.degrees(jumped ? 360 : 0))
                Text(jumped ? "SIUUU!" : "Ready?")
                    .font(.system(size: 72, weight: .black, design: .rounded))
                    .foregroundStyle(.yellow)
                    .scaleEffect(jumped ? 1.2 : 1)
                Spacer()
                Button {
                    jumped.toggle()
                } label: {
                    BigButtonLabel(text: jumped ? "Land" : "Jump")
                }
                NavigationLink {
                    CounterView()
                } label: {
                    Text("Your turn")
                        .font(.headline)
                }
            }
            .padding(32)
            .animation(.spring(response: 0.4, dampingFraction: 0.5), value: jumped)
        }
    }
}

struct CounterView: View {
    @State private var count = 0

    var body: some View {
        ZStack {
            PitchBackground()
            VStack(spacing: 24) {
                Spacer()
                BigTitle(text: "How many can you do?")
                Text("\(count)")
                    .font(.system(size: 120, weight: .black, design: .rounded))
                    .foregroundStyle(.yellow)
                Text(count == 1 ? "Suiii" : "Suiiis")
                    .font(.title)
                    .foregroundStyle(.white)
                Spacer()
                Button {
                    count += 1
                } label: {
                    BigButtonLabel(text: "Suiii!")
                }
                Button("Start over") {
                    count = 0
                }
            }
            .padding(32)
        }
    }
}

struct ContentView: View {
    var body: some View {
        NavigationStack {
            IntroView()
        }
        .tint(.white)
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
}
