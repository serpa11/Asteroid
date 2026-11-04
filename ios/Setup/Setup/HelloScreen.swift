import SwiftUI

/// First screen: wallpaper, cycling handwritten greeting, one Start button.
/// Deliberately no "swipe up to continue" hint.
struct HelloScreen: View {
    let onStart: () -> Void

    @State private var wordIndex = 0
    @State private var startVisible = false

    private let words = [
        "hello", "hola", "bonjour", "hallo", "ciao",
        "olá", "こんにちは", "안녕하세요", "привет", "你好"
    ]

    var body: some View {
        ZStack {
            WallpaperImage()
                .ignoresSafeArea()

            LinearGradient(
                colors: [
                    .black.opacity(0.18),
                    .black.opacity(0.04),
                    .black.opacity(0.46)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer(minLength: 40)

                TypewriterWord(text: words[wordIndex])
                    .id(wordIndex)

                Spacer(minLength: 40)

                Button(action: onStart) {
                    Text("Start")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 54)
                        .background(Capsule().fill(.ultraThinMaterial))
                        .overlay(Capsule().fill(.white.opacity(0.18)))
                        .glassSurface(Capsule())
                }
                .buttonStyle(.plain)
                .padding(.horizontal, 64)
                .padding(.bottom, 48)
                .opacity(startVisible ? 1 : 0)
                .offset(y: startVisible ? 0 : 16)
            }
        }
        .task {
            withAnimation(.easeOut(duration: 0.7).delay(0.45)) {
                startVisible = true
            }
            while !Task.isCancelled {
                try? await Task.sleep(nanoseconds: 3_600_000_000)
                guard !Task.isCancelled else { break }
                withAnimation(.easeInOut(duration: 0.28)) {
                    wordIndex = (wordIndex + 1) % words.count
                }
            }
        }
    }
}

/// Reveals the greeting one character at a time, like the real hello animation.
private struct TypewriterWord: View {
    let text: String

    @State private var revealed = 0

    var body: some View {
        HStack(spacing: 0) {
            ForEach(Array(text.enumerated()), id: \.offset) { index, character in
                Text(String(character))
                    .opacity(index < revealed ? 1 : 0)
            }
        }
        .font(.system(size: 78, weight: .semibold, design: .rounded))
        .foregroundStyle(.white)
        .shadow(color: .black.opacity(0.32), radius: 20, y: 7)
        .task {
            for index in 0...max(text.count, 1) {
                revealed = min(index, text.count)
                try? await Task.sleep(nanoseconds: 95_000_000)
            }
        }
    }
}
