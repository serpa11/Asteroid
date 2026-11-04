import SwiftUI

struct CameraControlScreen: View {
    let onBack: () -> Void
    let onContinue: () -> Void

    var body: some View {
        SetupScaffold(
            showBack: true,
            onBack: onBack,
            header: { EmptyView() },
            content: {
                VStack(spacing: 0) {
                    Spacer(minLength: 12)

                    CameraControlIllustration()
                        .padding(.bottom, 34)

                    SetupTitle(text: "Camera Control", centered: true)

                    SetupBodyText(
                        text: "Press the Camera Control button to open the Camera instantly. Press it again to take a photo, or slide your finger across the button to zoom.",
                        centered: true
                    )
                    .padding(.top, 14)

                    Spacer(minLength: 12)
                }
            },
            footer: {
                PrimaryButton(title: "Continue", action: onContinue)
            }
        )
    }
}

private struct CameraControlIllustration: View {
    @State private var pulse = false

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30, style: .continuous)
                .strokeBorder(Color.primary.opacity(0.22), lineWidth: 3)
                .frame(width: 134, height: 264)

            Image(systemName: "camera.fill")
                .font(.system(size: 34))
                .foregroundStyle(Color.secondary.opacity(0.5))

            RoundedRectangle(cornerRadius: 3)
                .fill(Color.blue)
                .frame(width: 5, height: 56)
                .offset(x: 71)

            RoundedRectangle(cornerRadius: 4)
                .fill(Color.blue.opacity(pulse ? 0.35 : 0.0))
                .frame(width: 15, height: 70)
                .offset(x: 71)
                .blur(radius: 6)
        }
        .frame(width: 170, height: 280)
        .onAppear {
            withAnimation(.easeInOut(duration: 1.1).repeatForever(autoreverses: true)) {
                pulse = true
            }
        }
    }
}
