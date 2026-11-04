import SwiftUI
import UIKit

struct AppearanceScreen: View {
    @Binding var selection: AppearanceChoice
    let onBack: () -> Void
    let onContinue: () -> Void

    var body: some View {
        SetupScaffold(
            showBack: true,
            onBack: onBack,
            header: {
                VStack(alignment: .leading, spacing: 12) {
                    SetupTitle(text: "Appearance")
                    SetupBodyText(
                        text: "Choose how Setup and your iPhone should look. Dark mode uses black, light mode uses white."
                    )
                }
            },
            content: {
                ScrollView {
                    VStack(spacing: 14) {
                        ForEach(AppearanceChoice.allCases) { choice in
                            AppearanceCard(
                                choice: choice,
                                isSelected: selection == choice
                            ) {
                                selection = choice
                            }
                        }
                    }
                    .padding(.horizontal, 24)
                    .padding(.vertical, 10)
                }
            },
            footer: {
                PrimaryButton(title: "Continue", action: onContinue)
            }
        )
    }
}

private struct AppearanceCard: View {
    let choice: AppearanceChoice
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            VStack(spacing: 12) {
                preview
                    .frame(height: 116)
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .strokeBorder(
                                isSelected ? Color.blue : Color.primary.opacity(0.14),
                                lineWidth: isSelected ? 2.5 : 1
                            )
                    }

                HStack {
                    Text(choice.title)
                        .font(.system(size: 16, weight: .medium))
                        .foregroundStyle(Color.primary)
                    Spacer(minLength: 8)
                    if isSelected {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 20))
                            .foregroundStyle(Color.blue)
                    }
                }
            }
            .padding(12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color(.secondarySystemBackground))
            )
            .glassSurface(RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    private var preview: some View {
        ZStack {
            switch choice {
            case .auto:
                LinearGradient(
                    colors: [.white, .black],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            case .light:
                Color.white
            case .dark:
                Color.black
            }

            VStack(alignment: .leading, spacing: 7) {
                Circle()
                    .fill(foreground.opacity(0.9))
                    .frame(width: 16, height: 16)
                RoundedRectangle(cornerRadius: 3)
                    .fill(foreground.opacity(0.4))
                    .frame(width: 78, height: 7)
                RoundedRectangle(cornerRadius: 3)
                    .fill(foreground.opacity(0.25))
                    .frame(width: 54, height: 7)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            .padding(16)
        }
    }

    private var foreground: Color {
        switch choice {
        case .auto: return .gray
        case .light: return .black
        case .dark: return .white
        }
    }
}
