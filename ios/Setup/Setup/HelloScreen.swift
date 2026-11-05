import SwiftUI
import UIKit

/// The setup opening: the wallpaper fades up, a liquid-glass Apple mark gathers
/// out of the blur, and it dissolves straight into the greeting — which then
/// cycles through languages until the screen is touched.
///
/// No start button: the whole screen is the control, with a fading reminder
/// at the bottom telling you when it is ready.
struct HelloScreen: View {
    let onStart: () -> Void

    @State private var wallpaperVisible = false
    @State private var markVisible = false
    @State private var markGone = false
    @State private var greetingShown = false
    @State private var canAdvance = false
    @State private var hintVisible = false
    @State private var wordIndex = 0

    private let words = [
        "hello", "hola", "bonjour", "hallo", "ciao",
        "olá", "こんにちは", "안녕하세요", "привет", "你好"
    ]

    var body: some View {
        ZStack {
            WallpaperImage()
                .opacity(wallpaperVisible ? 1 : 0)
                .scaleEffect(wallpaperVisible ? 1 : 1.07)
                .ignoresSafeArea()

            LinearGradient(
                colors: [
                    .black.opacity(0.20),
                    .black.opacity(0.05),
                    .black.opacity(0.48)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .opacity(wallpaperVisible ? 1 : 0)
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer(minLength: 40)

                ZStack {
                    AppleGlassMark()
                        .opacity(markVisible && !markGone ? 1 : 0)
                        .scaleEffect(markGone ? 1.34 : (markVisible ? 1 : 0.55))
                        .blur(radius: markGone ? 17 : (markVisible ? 0 : 11))
                        .allowsHitTesting(false)

                    if greetingShown {
                        GreetingText(text: words[wordIndex])
                            .id(wordIndex)
                    }
                }
                .frame(height: 168)

                Spacer(minLength: 40)

                Text("Touch the screen to continue")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.white.opacity(0.96))
                    .shadow(color: .black.opacity(0.5), radius: 10, y: 4)
                    .opacity(hintVisible ? 1 : 0)
                    .padding(.bottom, 54)
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            guard canAdvance else { return }
            onStart()
        }
        .task { await runOpening() }
        .task { await pulseHint() }
        .task { await cycleGreetings() }
    }

    // MARK: - Timeline

    private func runOpening() async {
        withAnimation(.easeOut(duration: 1.25)) {
            wallpaperVisible = true
        }
        await pause(0.55)

        withAnimation(.spring(response: 0.75, dampingFraction: 0.72)) {
            markVisible = true
        }
        await pause(1.55)

        greetingShown = true
        withAnimation(.easeIn(duration: 0.75)) {
            markGone = true
        }
        await pause(0.95)

        canAdvance = true
    }

    private func pulseHint() async {
        await pause(3.1)
        while !Task.isCancelled {
            withAnimation(.easeInOut(duration: 0.8)) {
                hintVisible = true
            }
            await pause(2.1)
            withAnimation(.easeInOut(duration: 0.8)) {
                hintVisible = false
            }
            await pause(1.4)
        }
    }

    private func cycleGreetings() async {
        await pause(4.6)
        while !Task.isCancelled {
            await pause(3.3)
            guard !Task.isCancelled else { break }
            withAnimation(.easeInOut(duration: 0.34)) {
                wordIndex = (wordIndex + 1) % words.count
            }
        }
    }

    private func pause(_ seconds: Double) async {
        try? await Task.sleep(nanoseconds: UInt64(seconds * 1_000_000_000))
    }
}

// MARK: - Liquid glass Apple mark

private struct AppleGlassMark: View {
    var body: some View {
        ZStack {
            Circle()
                .frame(width: 138, height: 138)
                .glassSurface(Circle())

            Image(systemName: "apple.logo")
                .font(.system(size: 56, weight: .regular))
                .foregroundStyle(
                    LinearGradient(
                        colors: [.white, .white.opacity(0.70), .white],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .shadow(color: .black.opacity(0.40), radius: 12, y: 5)
                .offset(y: -2)
        }
        .frame(width: 138, height: 138)
    }
}

// MARK: - Greeting

/// Chrome-glass lettering that reveals itself as it lands.
private struct GreetingText: View {
    let text: String

    @State private var shown = false

    var body: some View {
        Text(text)
            .font(.system(size: 78, weight: .semibold, design: .rounded))
            .lineLimit(1)
            .minimumScaleFactor(0.38)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 24)
            .foregroundStyle(
                LinearGradient(
                    stops: [
                        .init(color: .white.opacity(0.98), location: 0),
                        .init(color: .white.opacity(0.60), location: 0.42),
                        .init(color: .white, location: 0.58),
                        .init(color: .white.opacity(0.86), location: 1)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .shadow(color: .black.opacity(0.42), radius: 20, y: 9)
            .shadow(color: .white.opacity(0.32), radius: 1, y: -1)
            .opacity(shown ? 1 : 0)
            .scaleEffect(shown ? 1 : 1.24)
            .blur(radius: shown ? 0 : 12)
            .onAppear {
                withAnimation(.easeOut(duration: 0.62)) {
                    shown = true
                }
            }
    }
}
