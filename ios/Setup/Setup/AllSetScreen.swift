import SwiftUI

struct AllSetScreen: View {
    let language: String
    let region: String
    let mode: SiriMode
    let variety: SiriVariety
    let voiceIndex: Int
    let appearance: AppearanceChoice
    let onGetStarted: () -> Void

    var body: some View {
        SetupScaffold(
            header: {
                VStack(spacing: 0) {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 70))
                        .foregroundStyle(Color.blue)
                        .padding(.bottom, 22)

                    SetupTitle(text: "You're All Set", centered: true)

                    SetupBodyText(
                        text: "Your iPhone is ready. Here's what you chose.",
                        centered: true
                    )
                    .padding(.top, 12)
                }
                .padding(.bottom, 6)
            },
            content: {
                ScrollView {
                    VStack(spacing: 10) {
                        SummaryRow(label: "Language", value: language)
                        SummaryRow(label: "Region", value: region)
                        SummaryRow(label: "Siri", value: mode.title)
                        SummaryRow(
                            label: "Voice",
                            value: "\(variety.rawValue) · Voice \(voiceIndex + 1)"
                        )
                        SummaryRow(label: "Appearance", value: appearance.title)
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 12)
                }
            },
            footer: {
                PrimaryButton(title: "Get Started", action: onGetStarted)
            }
        )
    }
}
