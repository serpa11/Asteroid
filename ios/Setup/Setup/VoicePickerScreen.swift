import SwiftUI
import UIKit
import AVFoundation

/// Speaks the voice previews with the system speech engine.
final class VoicePreviewer {
    static let shared = VoicePreviewer()

    private let synthesizer = AVSpeechSynthesizer()

    func speak(_ text: String, language: String) {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
        let utterance = AVSpeechUtterance(string: text)
        utterance.rate = AVSpeechUtteranceDefaultSpeechRate
        utterance.voice = AVSpeechSynthesisVoice(language: language)
        synthesizer.speak(utterance)
    }

    func stop() {
        if synthesizer.isSpeaking {
            synthesizer.stopSpeaking(at: .immediate)
        }
    }
}

/// Voice chooser: variety menu plus a list of voices with live previews.
struct VoicePickerScreen: View {
    @Binding var variety: SiriVariety
    @Binding var selection: Int
    let onBack: () -> Void
    let onContinue: () -> Void

    private let voices = ["Voice 1", "Voice 2", "Voice 3", "Voice 4", "Voice 5", "Voice 6"]

    var body: some View {
        SetupScaffold(
            showBack: true,
            onBack: onBack,
            header: {
                VStack(alignment: .leading, spacing: 18) {
                    SetupTitle(text: "Siri Voice")
                    SetupBodyText(text: "Pick a variety, then tap a voice to hear it.")

                    Menu {
                        ForEach(SiriVariety.allCases) { option in
                            Button(option.rawValue) {
                                variety = option
                            }
                        }
                    } label: {
                        HStack(spacing: 10) {
                            Text("Variety")
                                .font(.system(size: 17))
                                .foregroundStyle(Color.primary)
                            Spacer(minLength: 8)
                            Text(variety.rawValue)
                                .font(.system(size: 17))
                                .foregroundStyle(Color.secondary)
                            Image(systemName: "chevron.right")
                                .font(.system(size: 13, weight: .semibold))
                                .foregroundStyle(Color.secondary.opacity(0.7))
                        }
                        .padding(.horizontal, 16)
                        .frame(height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(Color(.secondarySystemBackground))
                        )
                        .glassSurface(RoundedRectangle(cornerRadius: 14, style: .continuous))
                        .padding(.horizontal, 24)
                    }
                }
            },
            content: {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(Array(voices.enumerated()), id: \.offset) { index, name in
                            HStack(spacing: 14) {
                                Button {
                                    VoicePreviewer.shared.speak(
                                        "Hi, I'm Siri. This is \(name) speaking.",
                                        language: variety.languageCode
                                    )
                                } label: {
                                    Image(systemName: "play.circle.fill")
                                        .font(.system(size: 27))
                                        .foregroundStyle(Color.blue)
                                }
                                .buttonStyle(.plain)

                                Text(name)
                                    .font(.system(size: 17))
                                    .foregroundStyle(Color.primary)

                                Spacer(minLength: 12)

                                if selection == index {
                                    Image(systemName: "checkmark")
                                        .font(.system(size: 15, weight: .semibold))
                                        .foregroundStyle(Color.blue)
                                }
                            }
                            .padding(.horizontal, 24)
                            .frame(minHeight: 54)
                            .contentShape(Rectangle())
                            .onTapGesture { selection = index }

                            Divider()
                                .padding(.leading, 24)
                        }
                    }
                    .padding(.top, 8)
                }
            },
            footer: {
                PrimaryButton(title: "Continue", action: onContinue)
            }
        )
        .onDisappear { VoicePreviewer.shared.stop() }
    }
}
