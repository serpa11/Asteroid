import SwiftUI
import UIKit

// MARK: - Flow

enum SetupStep: Int, CaseIterable, Equatable {
    case hello
    case welcome
    case language
    case region
    case dataPrivacy
    case cameraControl
    case locationServices
    case faceID
    case analytics
    case softwareUpdate
    case displayZoom
    case displayAppearance
    case siri
    case voicePicker
    case welcomeToIPhone
}

enum AppearanceChoice: String, CaseIterable, Identifiable {
    case light
    case dark

    var id: String { rawValue }

    var title: String {
        switch self {
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
}

enum SiriVariety: String, CaseIterable, Identifiable {
    case american = "American"
    case british = "British"
    case australian = "Australian"
    case indian = "Indian"
    case irish = "Irish"
    case southAfrican = "South African"

    var id: String { rawValue }

    var languageCode: String {
        switch self {
        case .american: return "en-US"
        case .british: return "en-GB"
        case .australian: return "en-AU"
        case .indian: return "en-IN"
        case .irish: return "en-IE"
        case .southAfrican: return "en-ZA"
        }
    }
}

// MARK: - Copy

enum SetupData {
    static let languages: [String] = [
        "English (United States)",
        "English (United Kingdom)",
        "English (Australia)",
        "English (Canada)",
        "Español (España)",
        "Español (México)",
        "Français (France)",
        "Français (Canada)",
        "Deutsch (Deutschland)",
        "Italiano",
        "Português (Brasil)",
        "Português (Portugal)",
        "Nederlands",
        "Polski",
        "Türkçe",
        "Русский",
        "Українська",
        "简体中文",
        "繁體中文（台灣）",
        "日本語",
        "한국어",
        "العربية",
        "हिन्दी",
        "ไทย",
        "Tiếng Việt",
        "Bahasa Indonesia",
        "Bahasa Melayu",
        "Čeština",
        "Română",
        "Magyar",
        "Svenska",
        "Dansk",
        "Norsk",
        "Suomi",
        "Ελληνικά",
        "עברית",
        "Català"
    ]

    static let regions: [String] = [
        "United States",
        "United Kingdom",
        "Canada",
        "Australia",
        "Ireland",
        "New Zealand",
        "Afghanistan",
        "Argentina",
        "Belgium",
        "Brazil",
        "Chile",
        "China",
        "Colombia",
        "Croatia",
        "Czechia",
        "Denmark",
        "Egypt",
        "Estonia",
        "Finland",
        "France",
        "Germany",
        "Greece",
        "Hong Kong",
        "Hungary",
        "India",
        "Indonesia",
        "Israel",
        "Italy",
        "Japan",
        "Latvia",
        "Lithuania",
        "Malaysia",
        "Mexico",
        "Netherlands",
        "Norway",
        "Philippines",
        "Poland",
        "Portugal",
        "Romania",
        "Saudi Arabia",
        "Singapore",
        "Slovakia",
        "South Africa",
        "South Korea",
        "Spain",
        "Sweden",
        "Switzerland",
        "Taiwan",
        "Thailand",
        "Turkey",
        "Ukraine",
        "United Arab Emirates",
        "Vietnam"
    ].sorted()
}

// MARK: - Root

struct SetupRootView: View {
    @State private var step: SetupStep = .hello
    @State private var isForward = true

    @State private var language = "English (United States)"
    @State private var region = "United States"
    @State private var variety: SiriVariety = .american
    @State private var voiceIndex = 0
    @State private var displayZoom: DisplayZoomChoice = .zoomed
    @State private var appearance: AppearanceChoice = .light

    var body: some View {
        ZStack {
            currentScreen
        }
        .preferredColorScheme(colorScheme)
    }

    private var colorScheme: ColorScheme? {
        switch appearance {
        case .light: return .light
        case .dark: return .dark
        }
    }

    private var currentScreen: some View {
        Group {
            switch step {
            case .hello:
                HelloScreen(onStart: advance)
            case .welcome:
                WelcomeScreen(onGetStarted: advance)
            case .language:
                LanguageScreen(selection: $language, onBack: goBack, onContinue: advance)
            case .region:
                RegionScreen(selection: $region, onBack: goBack, onContinue: advance)
            case .dataPrivacy:
                DataPrivacyScreen(onBack: goBack, onContinue: advance)
            case .cameraControl:
                CameraControlScreen(onBack: goBack, onContinue: advance)
            case .locationServices:
                LocationServicesScreen(onBack: goBack, onContinue: advance)
            case .faceID:
                FaceIDScreen(onBack: goBack, onContinue: advance)
            case .analytics:
                AnalyticsScreen(onBack: goBack, onContinue: advance)
            case .softwareUpdate:
                SoftwareUpdateScreen(onBack: goBack, onContinue: advance)
            case .displayZoom:
                DisplayZoomScreen(
                    selection: $displayZoom,
                    onBack: goBack,
                    onContinue: advance
                )
            case .displayAppearance:
                AppearanceScreen(
                    selection: $appearance,
                    onBack: goBack,
                    onContinue: advance
                )
            case .siri:
                SiriScreen(
                    onBack: goBack,
                    onContinue: { advance(to: .welcomeToIPhone) },
                    onSetUp: { advance(to: .voicePicker) }
                )
            case .voicePicker:
                VoicePickerScreen(
                    variety: $variety,
                    selection: $voiceIndex,
                    onBack: goBack,
                    onContinue: advance
                )
            case .welcomeToIPhone:
                WelcomeToIPhoneScreen(onFinish: closeSetup)
            }
        }
        .transition(
            .move(edge: isForward ? .trailing : .leading)
                .combined(with: .opacity)
        )
        .id(step)
    }

    private func advance() {
        guard let next = SetupStep(rawValue: step.rawValue + 1) else { return }
        move(to: next)
    }

    private func advance(to target: SetupStep) {
        move(to: target)
    }

    private func move(to target: SetupStep) {
        withAnimation(.easeInOut(duration: 0.34)) {
            isForward = target.rawValue > step.rawValue
            step = target
        }
    }

    private func goBack() {
        guard let previous = SetupStep(rawValue: step.rawValue - 1) else { return }
        move(to: previous)
    }

    /// Setup is over — close the app so you land on the real home screen.
    private func closeSetup() {
        exit(0)
    }
}
