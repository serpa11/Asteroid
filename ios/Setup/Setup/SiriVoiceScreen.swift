import SwiftUI

/// "Siri & Voice" — the Apple Intelligence Classic / Siri AI switcher lives here.
struct SiriVoiceScreen: View {
    @Binding var mode: SiriMode
    let onBack: () -> Void
    let onContinue: () -> Void

    var body: some View {
        SetupScaffold(
            showBack: true,
            onBack: onBack,
            header: {
                VStack(alignment: .leading, spacing: 12) {
                    SetupTitle(text: "Siri & Voice")
                    SetupBodyText(
                        text: "Choose how Siri should work on this iPhone. You can switch between them at any time in Settings."
                    )
                }
            },
            content: {
                ScrollView {
                    VStack(spacing: 14) {
                        ForEach(SiriMode.allCases) { option in
                            OptionCard(
                                title: option.title,
                                subtitle: option.subtitle,
                                symbol: option.symbol,
                                isSelected: mode == option
                            ) {
                                mode = option
                            }
                        }

                        SetupBodyText(text: mode.detail)
                            .padding(.top, 6)
                    }
                    .padding(.vertical, 10)
                }
            },
            footer: {
                PrimaryButton(title: "Continue", action: onContinue)
            }
        )
    }
}
