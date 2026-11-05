import SwiftUI
import UIKit

// MARK: - Shared info-screen scaffold

/// The layout every mid-flow setup screen in the screenshots shares:
/// plain back chevron, big glyph, centred title and body, optional rows,
/// then a liquid-glass primary button with an optional text button under it.
struct SetupInfoScreen: View {
    let onBack: () -> Void
    let icon: AnyView
    let title: String
    let text: String
    let primaryTitle: String
    let primaryAction: () -> Void
    let secondaryTitle: String?
    let secondaryAction: () -> Void
    let content: AnyView

    init(
        onBack: @escaping () -> Void,
        icon: AnyView,
        title: String,
        text: String,
        primaryTitle: String,
        primaryAction: @escaping () -> Void,
        secondaryTitle: String? = nil,
        secondaryAction: @escaping () -> Void = {},
        content: AnyView = AnyView(EmptyView())
    ) {
        self.onBack = onBack
        self.icon = icon
        self.title = title
        self.text = text
        self.primaryTitle = primaryTitle
        self.primaryAction = primaryAction
        self.secondaryTitle = secondaryTitle
        self.secondaryAction = secondaryAction
        self.content = content
    }

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    BackButton(action: onBack)
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 16)
                .padding(.top, 6)

                ScrollView {
                    VStack(spacing: 0) {
                        icon
                            .padding(.top, 26)
                            .padding(.bottom, 20)

                        Text(title)
                            .font(.system(size: 31, weight: .bold))
                            .foregroundStyle(Color.primary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 24)

                        Text(text)
                            .font(.system(size: 16.5))
                            .lineSpacing(5)
                            .foregroundStyle(Color.primary)
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(.horizontal, 36)
                            .padding(.top, 15)

                        content
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.bottom, 18)
                }

                VStack(spacing: 14) {
                    PrimaryButton(title: primaryTitle, action: primaryAction)

                    if let secondaryTitle {
                        Button(action: secondaryAction) {
                            Text(secondaryTitle)
                                .font(.system(size: 17))
                                .foregroundStyle(Color.blue)
                                .frame(maxWidth: .infinity)
                                .frame(height: 30)
                                .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 22)
                .padding(.top, 10)
                .padding(.bottom, 24)
            }
        }
    }
}

// MARK: - Rows

/// The inset grouped block the choice rows sit in.
struct SetupRowGroup<Content: View>: View {
    private let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: 14, style: .continuous)
    }

    var body: some View {
        content
            .background(Color(.secondarySystemBackground), in: shape)
            .clipShape(shape)
            .glassSurface(shape)
            .padding(.top, 24)
            .padding(.horizontal, 20)
    }
}

/// A row with a leading radio dot — Display Zoom and Display Appearance.
struct SetupRadioRow: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 22))
                    .foregroundStyle(isSelected ? Color.blue : Color.secondary.opacity(0.45))

                Text(title)
                    .font(.system(size: 17))
                    .foregroundStyle(Color.primary)

                Spacer(minLength: 8)
            }
            .padding(.horizontal, 18)
            .frame(height: 56)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.16), value: isSelected)
    }
}

/// A row with a trailing tick — Software Update.
struct SetupCheckRow: View {
    let title: String
    let isOn: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                Text(title)
                    .font(.system(size: 17))
                    .foregroundStyle(Color.primary)

                Spacer(minLength: 12)

                Image(systemName: "checkmark")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Color.blue)
                    .opacity(isOn ? 1 : 0)
            }
            .padding(.horizontal, 18)
            .frame(height: 56)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .animation(.easeInOut(duration: 0.18), value: isOn)
    }
}

// MARK: - Icons from the screenshots

struct GlobeIcon: View {
    var body: some View {
        Image(systemName: "globe")
            .font(.system(size: 104, weight: .regular))
            .foregroundStyle(
                LinearGradient(
                    colors: [
                        Color(red: 0.65, green: 0.72, blue: 0.78),
                        Color(red: 0.44, green: 0.53, blue: 0.61)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(height: 126)
    }
}

struct FaceIDIcon: View {
    var body: some View {
        Image(systemName: "faceid")
            .font(.system(size: 100, weight: .regular))
            .foregroundStyle(Color(red: 0.98, green: 0.75, blue: 0.05))
            .frame(height: 126)
    }
}

struct AnalyticsIcon: View {
    private let baseline = Color(red: 0.79, green: 0.79, blue: 0.82)

    var body: some View {
        VStack(spacing: 7) {
            HStack(alignment: .bottom, spacing: 11) {
                bar(height: 44, color: Color(red: 0.16, green: 0.58, blue: 0.97))
                bar(height: 76, color: Color(red: 0.55, green: 0.36, blue: 0.93))
                bar(height: 58, color: Color(red: 0.18, green: 0.78, blue: 0.80))
            }

            RoundedRectangle(cornerRadius: 4)
                .fill(baseline)
                .frame(width: 124, height: 9)
        }
        .frame(height: 126)
    }

    private func bar(height: CGFloat, color: Color) -> some View {
        RoundedRectangle(cornerRadius: 7)
            .fill(color)
            .frame(width: 28, height: height)
    }
}

struct SoftwareUpdateIcon: View {
    private let blue = Color(red: 0.16, green: 0.58, blue: 0.97)

    var body: some View {
        VStack(spacing: 3) {
            Image(systemName: "arrow.down")
                .font(.system(size: 76, weight: .regular))
                .foregroundStyle(blue)

            RoundedRectangle(cornerRadius: 4)
                .fill(blue)
                .frame(width: 106, height: 11)
        }
        .frame(height: 126)
    }
}

struct DisplayZoomIcon: View {
    private let blue = Color(red: 0.16, green: 0.58, blue: 0.97)

    var body: some View {
        HStack(alignment: .bottom, spacing: 11) {
            phone(width: 48, height: 84)
            phone(width: 68, height: 116)
        }
        .frame(height: 126)
    }

    private func phone(width: CGFloat, height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 12, style: .continuous)
            .fill(Color(.systemBackground))
            .overlay {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .strokeBorder(blue, lineWidth: 5)
            }
            .frame(width: width, height: height)
    }
}

struct DisplayAppearanceIcon: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 27, style: .continuous)
                .fill(Color.white)

            ZStack {
                Circle()
                    .fill(Color.white)

                HStack(spacing: 0) {
                    Color.black
                    Color.white
                }
                .frame(width: 94, height: 94)
                .clipShape(Circle())

                Circle()
                    .strokeBorder(Color.black, lineWidth: 5)
                    .frame(width: 94, height: 94)
            }
            .frame(width: 94, height: 94)

            RoundedRectangle(cornerRadius: 27, style: .continuous)
                .strokeBorder(Color.black, lineWidth: 6)
        }
        .frame(width: 124, height: 126)
    }
}

struct SiriOrbIcon: View {
    @State private var spin = false

    private let orbSize: CGFloat = 126

    private var colors: [Color] {
        [
            Color(red: 1.00, green: 0.42, blue: 0.21),
            Color(red: 0.98, green: 0.20, blue: 0.35),
            Color(red: 0.72, green: 0.24, blue: 0.94),
            Color(red: 0.35, green: 0.30, blue: 0.96),
            Color(red: 0.15, green: 0.58, blue: 0.98),
            Color(red: 0.16, green: 0.80, blue: 0.88),
            Color(red: 0.24, green: 0.84, blue: 0.50),
            Color(red: 1.00, green: 0.76, blue: 0.24),
            Color(red: 1.00, green: 0.42, blue: 0.21)
        ]
    }

    var body: some View {
        ZStack {
            Circle()
                .fill(
                    AngularGradient(colors: colors, center: .center)
                )
                .frame(width: orbSize, height: orbSize)
                .blur(radius: 7)
                .clipShape(Circle())
                .rotationEffect(.degrees(spin ? 360 : 0))

            Circle()
                .fill(
                    RadialGradient(
                        colors: [.white.opacity(0.72), .white.opacity(0.0)],
                        center: UnitPoint(x: 0.34, y: 0.27),
                        startRadius: 0,
                        endRadius: 68
                    )
                )
                .frame(width: orbSize, height: orbSize)

            Circle()
                .strokeBorder(Color.white.opacity(0.42), lineWidth: 1)
                .frame(width: orbSize, height: orbSize)
        }
        .frame(width: orbSize, height: orbSize)
        .shadow(color: Color.purple.opacity(0.42), radius: 34, y: 12)
        .onAppear {
            withAnimation(.linear(duration: 16).repeatForever(autoreverses: false)) {
                spin = true
            }
        }
    }
}

// MARK: - Location Services

struct LocationServicesScreen: View {
    let onBack: () -> Void
    let onContinue: () -> Void

    var body: some View {
        SetupInfoScreen(
            onBack: onBack,
            icon: AnyView(GlobeIcon()),
            title: "Location Services",
            text: """
            Location Services lets apps and services like Maps, Camera, and Weather \
            access your approximate location, your location in the background, and \
            your exact location. These features depend on working Location Services \
            and require a connection to the internet.

            All location data is sent to Apple to improve Location Services. Your \
            iPhone will also send Apple daily diagnostic and usage data. The \
            information sent to Apple and its partners won't identify you personally.

            Tap any change button to review and adjust these settings.

            You can change your choice in Settings at any time.
            """,
            primaryTitle: "Continue",
            primaryAction: onContinue,
            secondaryTitle: "Disable Location Services",
            secondaryAction: onContinue
        )
    }
}

// MARK: - Face ID & Passcode

struct FaceIDScreen: View {
    let onBack: () -> Void
    let onContinue: () -> Void

    var body: some View {
        SetupInfoScreen(
            onBack: onBack,
            icon: AnyView(FaceIDIcon()),
            title: "Face ID & Passcode",
            text: """
            Use Face ID to unlock your iPhone and authorize App Store and iTunes \
            Store purchases, Apple Pay transactions, and other apps.

            To choose a passcode instead, tap Continue.
            """,
            primaryTitle: "Continue",
            primaryAction: onContinue,
            secondaryTitle: "Choose Passcode",
            secondaryAction: onContinue
        )
    }
}

// MARK: - Analytics

struct AnalyticsScreen: View {
    let onBack: () -> Void
    let onContinue: () -> Void

    var body: some View {
        SetupInfoScreen(
            onBack: onBack,
            icon: AnyView(AnalyticsIcon()),
            title: "Analytics",
            text: """
            App Analytics automatically sends your iPhone app usage data to Apple to \
            improve apps.

            Your iPhone will also send Apple daily diagnostic and usage data. The \
            information sent to Apple and its partners won't identify you personally.

            You can change your choice anytime.
            """,
            primaryTitle: "Share with Apple",
            primaryAction: onContinue,
            secondaryTitle: "Don't Share",
            secondaryAction: onContinue
        )
    }
}

// MARK: - Software Update

/// Two independent switches, so the choice is "download automatically",
/// "install automatically", or both.
struct SoftwareUpdateScreen: View {
    let onBack: () -> Void
    let onContinue: () -> Void

    @State private var download = true
    @State private var install = true

    var body: some View {
        SetupInfoScreen(
            onBack: onBack,
            icon: AnyView(SoftwareUpdateIcon()),
            title: "Software Update",
            text: """
            iPhone updates are an essential part of keeping your iPhone and data \
            secure. To keep it current, we'll download them automatically or you can \
            tap to download at any time from Settings.

            To update automatically overnight and install overnight when you're not \
            using it, tap Automatically Update.
            """,
            primaryTitle: "Continue",
            primaryAction: onContinue,
            content: AnyView(
                SetupRowGroup {
                    SetupCheckRow(title: "Download Updates Automatically", isOn: download) {
                        download.toggle()
                    }
                    Divider()
                    SetupCheckRow(title: "Install Updates Automatically", isOn: install) {
                        install.toggle()
                    }
                }
            )
        )
    }
}

// MARK: - Display Zoom

enum DisplayZoomChoice: String, CaseIterable, Identifiable {
    case zoomed
    case standard

    var id: String { rawValue }

    var title: String {
        switch self {
        case .zoomed: return "Zoomed"
        case .standard: return "Standard"
        }
    }
}

struct DisplayZoomScreen: View {
    @Binding var selection: DisplayZoomChoice
    let onBack: () -> Void
    let onContinue: () -> Void

    var body: some View {
        SetupInfoScreen(
            onBack: onBack,
            icon: AnyView(DisplayZoomIcon()),
            title: "Display Zoom",
            text: """
            Choose the display zoom setting you'd prefer. Zoomed displays larger \
            icons and text. This setting can be changed in Settings > Display & \
            Brightness.
            """,
            primaryTitle: "Continue",
            primaryAction: onContinue,
            content: AnyView(
                SetupRowGroup {
                    SetupRadioRow(title: "Zoomed", isSelected: selection == .zoomed) {
                        selection = .zoomed
                    }
                    Divider()
                    SetupRadioRow(title: "Standard", isSelected: selection == .standard) {
                        selection = .standard
                    }
                }
            )
        )
    }
}

// MARK: - Siri

/// Plain Siri — no Apple Intelligence, no Siri AI.
struct SiriScreen: View {
    let onBack: () -> Void
    let onContinue: () -> Void
    let onSetUp: () -> Void

    var body: some View {
        SetupInfoScreen(
            onBack: onBack,
            icon: AnyView(SiriOrbIcon()),
            title: "Siri",
            text: "Siri is your onscreen personal assistant. You can get things done with just your voice.",
            primaryTitle: "Continue",
            primaryAction: onContinue,
            secondaryTitle: "Set Up Siri",
            secondaryAction: onSetUp
        )
    }
}

// MARK: - Welcome to iPhone

/// The last screen: swipe up (or tap) closes the app so you land on the
/// real home screen, exactly like the end of real setup.
struct WelcomeToIPhoneScreen: View {
    let onFinish: () -> Void

    @State private var appeared = false
    @State private var finished = false

    var body: some View {
        ZStack {
            WallpaperImage()
                .ignoresSafeArea()

            LinearGradient(
                colors: [
                    .black.opacity(0.16),
                    .black.opacity(0.04),
                    .black.opacity(0.46)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer(minLength: 40)

                Text("Welcome to iPhone")
                    .font(.system(size: 40, weight: .bold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .shadow(color: .black.opacity(0.35), radius: 18, y: 6)

                Text("Swipe up to begin")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.white.opacity(0.95))
                    .padding(.top, 16)
                    .shadow(color: .black.opacity(0.4), radius: 10, y: 4)

                Spacer(minLength: 40)
            }
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 16)
        }
        .contentShape(Rectangle())
        .onTapGesture { finish() }
        .gesture(
            DragGesture(minimumDistance: 24)
                .onEnded { value in
                    if value.translation.height < -40 {
                        finish()
                    }
                }
        )
        .task {
            withAnimation(.easeOut(duration: 0.7)) {
                appeared = true
            }
        }
    }

    private func finish() {
        guard !finished else { return }
        finished = true
        onFinish()
    }
}
