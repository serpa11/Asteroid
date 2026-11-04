import SwiftUI

/// Update success screen — the only place the OS version is mentioned.
struct WelcomeScreen: View {
    let onGetStarted: () -> Void

    var body: some View {
        ZStack {
            WallpaperImage()
                .ignoresSafeArea()

            LinearGradient(
                colors: [
                    .black.opacity(0.42),
                    .black.opacity(0.16),
                    .black.opacity(0.5)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer(minLength: 32)

                UpdateSuccessfulLogo()
                    .padding(.bottom, 30)

                Text("Your device is now running iOS 28!")
                    .font(.system(size: 32, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.horizontal, 30)
                    .shadow(color: .black.opacity(0.3), radius: 16, y: 5)

                Text("Software Update Complete")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.white.opacity(0.86))
                    .padding(.top, 16)

                Spacer(minLength: 32)

                PrimaryButton(title: "Get Started", action: onGetStarted)
                    .padding(.horizontal, 44)
                    .padding(.bottom, 48)
            }
        }
    }
}

/// The iOS "update successful" mark, drawn with SF Symbols so it renders
/// with the system's own artwork in every appearance.
struct UpdateSuccessfulLogo: View {
    @State private var appeared = false

    var body: some View {
        Image(systemName: "checkmark.circle.fill")
            .font(.system(size: 98, weight: .regular))
            .foregroundStyle(.white)
            .shadow(color: .black.opacity(0.38), radius: 22, y: 9)
            .scaleEffect(appeared ? 1 : 0.72)
            .opacity(appeared ? 1 : 0)
            .onAppear {
                withAnimation(.spring(response: 0.55, dampingFraction: 0.68)) {
                    appeared = true
                }
            }
    }
}
