import SwiftUI

struct DataPrivacyScreen: View {
    let onBack: () -> Void
    let onContinue: () -> Void

    var body: some View {
        SetupScaffold(
            showBack: true,
            onBack: onBack,
            header: { EmptyView() },
            content: {
                VStack(spacing: 0) {
                    Spacer(minLength: 20)

                    Image(systemName: "hand.raised.fill")
                        .font(.system(size: 50))
                        .foregroundStyle(.white)
                        .frame(width: 106, height: 106)
                        .background(
                            RoundedRectangle(cornerRadius: 25, style: .continuous)
                                .fill(
                                    LinearGradient(
                                        colors: [.blue, .indigo],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                        )
                        .padding(.bottom, 30)

                    SetupTitle(text: "Data & Privacy", centered: true)

                    SetupBodyText(
                        text: "When it comes to your data, it's your choice. You decide what to share with Apple, and you can change your mind at any time.",
                        centered: true
                    )
                    .padding(.top, 14)

                    Spacer(minLength: 20)
                }
            },
            footer: {
                PrimaryButton(title: "Continue", action: onContinue)
            }
        )
    }
}
