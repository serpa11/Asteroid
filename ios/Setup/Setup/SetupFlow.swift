import SwiftUI

// MARK: - Flow

enum SetupStep: Int, CaseIterable, Equatable {
    case hello
    case welcome
    case language
    case region
    case dataPrivacy
    case siriVoice
    case voicePicker
    case cameraControl
    case appearance
    case allSet
}

enum SiriMode: String, CaseIterable, Identifiable, Equatable {
    case classic
    case siriAI

    var id: String { rawValue }

    var title: String {
        switch self {
        case .classic: return "Apple Intelligence Classic"
        case .siriAI: return "Siri AI"
        }
    }

    var symbol: String {
        switch self {
        case .classic: return "sparkles"
        case .siriAI: return "waveform"
        }
    }

    var subtitle: String {
        switch self {
        case .classic:
            return "Writing tools, image playground and the original Siri personality."
        case .siriAI:
            return "Conversational context, on-screen awareness and actions across your apps."
        }
    }

    var detail: String {
        switch self {
        case .classic:
            return "Apple Intelligence Classic keeps the original Siri experience. Everything runs on device where possible, and features ask for permission the first time you use them."
        case .siriAI:
            return "Siri AI remembers what you were just doing, understands what is on your screen and can take steps for you. A supported device is required for the full experience."
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

enum AppearanceChoice: String, CaseIterable, Identifiable {
    case auto
    case light
    case dark

    var id: String { rawValue }

    var title: String {
        switch self {
        case .auto: return "Automatic"
        case .light: return "Light"
        case .dark: return "Dark"
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
    @State private var siriMode: SiriMode = .classic
    @State private var variety: SiriVariety = .american
    @State private var voiceIndex = 0
    @State private var appearance: AppearanceChoice = .auto

    var body: some View {
        ZStack {
            currentScreen
        }
        .preferredColorScheme(colorScheme)
    }

    private var colorScheme: ColorScheme? {
        switch appearance {
        case .auto: return nil
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
            case .siriVoice:
                SiriVoiceScreen(mode: $siriMode, onBack: goBack, onContinue: advance)
            case .voicePicker:
                VoicePickerScreen(
                    variety: $variety,
                    selection: $voiceIndex,
                    onBack: goBack,
                    onContinue: advance
                )
            case .cameraControl:
                CameraControlScreen(onBack: goBack, onContinue: advance)
            case .appearance:
                AppearanceScreen(selection: $appearance, onBack: goBack, onContinue: advance)
            case .allSet:
                AllSetScreen(
                    language: language,
                    region: region,
                    mode: siriMode,
                    variety: variety,
                    voiceIndex: voiceIndex,
                    appearance: appearance,
                    onGetStarted: restart
                )
            }
        }
        .transition(
            .move(edge: isForward ? .trailing : .leading)
                .combined(with: .opacity)
        )
        .id(step)
    }

    private func advance() {
        if step == .allSet {
            restart()
            return
        }
        guard let next = SetupStep(rawValue: step.rawValue + 1) else { return }
        withAnimation(.easeInOut(duration: 0.34)) {
            isForward = true
            step = next
        }
    }

    private func goBack() {
        guard let previous = SetupStep(rawValue: step.rawValue - 1) else { return }
        withAnimation(.easeInOut(duration: 0.34)) {
            isForward = false
            step = previous
        }
    }

    private func restart() {
        withAnimation(.easeInOut(duration: 0.34)) {
            isForward = true
            language = "English (United States)"
            region = "United States"
            siriMode = .classic
            variety = .american
            voiceIndex = 0
            appearance = .auto
            step = .hello
        }
    }
}
