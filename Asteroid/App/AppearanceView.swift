import SwiftUI
import Combine

final class AppearanceStore: ObservableObject {
    static let shared = AppearanceStore()

    @Published var preferredColorScheme = 0 { didSet { UserDefaults.standard.set(preferredColorScheme, forKey: "preferredColorScheme") } }
    @Published var appHaptics = true { didSet { UserDefaults.standard.set(appHaptics, forKey: "appHaptics") } }
    @Published var compactHome = false { didSet { UserDefaults.standard.set(compactHome, forKey: "compactHome") } }
    @Published var reduceMotion = false { didSet { UserDefaults.standard.set(reduceMotion, forKey: "reduceMotion") } }
    @Published var highContrast = false { didSet { UserDefaults.standard.set(highContrast, forKey: "highContrast") } }
    @Published var glassBorders = true { didSet { UserDefaults.standard.set(glassBorders, forKey: "glassBorders") } }
    @Published var fastAnimations = false { didSet { UserDefaults.standard.set(fastAnimations, forKey: "fastAnimations") } }
    @Published var appAccentMode = 0 { didSet { UserDefaults.standard.set(appAccentMode, forKey: "appAccentMode") } }
    @Published var appAccentRed = 0.92 { didSet { UserDefaults.standard.set(appAccentRed, forKey: "appAccentRed") } }
    @Published var appAccentGreen = 0.45 { didSet { UserDefaults.standard.set(appAccentGreen, forKey: "appAccentGreen") } }
    @Published var appAccentBlue = 0.33 { didSet { UserDefaults.standard.set(appAccentBlue, forKey: "appAccentBlue") } }

    init() {
        UserDefaults.standard.register(defaults: [
            "appHaptics": true,
            "glassBorders": true,
            "appAccentRed": 0.92,
            "appAccentGreen": 0.45,
            "appAccentBlue": 0.33
        ])
        preferredColorScheme = UserDefaults.standard.integer(forKey: "preferredColorScheme")
        appHaptics = UserDefaults.standard.object(forKey: "appHaptics") == nil ? true : UserDefaults.standard.bool(forKey: "appHaptics")
        compactHome = UserDefaults.standard.bool(forKey: "compactHome")
        reduceMotion = UserDefaults.standard.bool(forKey: "reduceMotion")
        highContrast = UserDefaults.standard.bool(forKey: "highContrast")
        glassBorders = UserDefaults.standard.object(forKey: "glassBorders") == nil ? true : UserDefaults.standard.bool(forKey: "glassBorders")
        fastAnimations = UserDefaults.standard.bool(forKey: "fastAnimations")
        appAccentMode = UserDefaults.standard.integer(forKey: "appAccentMode")
        if let red = UserDefaults.standard.object(forKey: "appAccentRed") as? Double { appAccentRed = red }
        if let green = UserDefaults.standard.object(forKey: "appAccentGreen") as? Double { appAccentGreen = green }
        if let blue = UserDefaults.standard.object(forKey: "appAccentBlue") as? Double { appAccentBlue = blue }
    }

    private func writeInt(_ key: String, _ newValue: Int) { UserDefaults.standard.set(newValue, forKey: key) }
    private func writeBool(_ key: String, _ newValue: Bool) { UserDefaults.standard.set(newValue, forKey: key) }
    private func writeDouble(_ key: String, _ newValue: Double) { UserDefaults.standard.set(newValue, forKey: key) }

    var appAccentColor: Color {
        switch appAccentMode {
        case 1: return .cyan
        case 2: return .yellow
        case 3:
            if appAccentRed > 0.95 || appAccentGreen > 0.95 || appAccentBlue > 0.95 ||
               appAccentRed < 0.05 || appAccentGreen < 0.05 || appAccentBlue < 0.05 { return .orange }
            return Color(red: appAccentRed, green: appAccentGreen, blue: appAccentBlue)
        default: return .orange
        }
    }

}

func appAccentColor() -> Color { AppearanceStore.shared.appAccentColor }

struct AppearanceView: View {
    @EnvironmentObject private var appearance: AppearanceStore
    @State private var customColor = AppearanceStore.shared.appAccentColor

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Appearance", selection: $appearance.preferredColorScheme) {
                        Text("System").tag(0)
                        Text("Light").tag(1)
                        Text("Dark").tag(2)
                    }
                    .pickerStyle(.segmented)
                } header: {
                    HeaderLabel("Appearance", symbol: "circle.lefthalf.filled")
                } footer: {
                    Text("Choose between System, Light, or Dark. Changes apply immediately.")
                }

                Section {
                    Picker("Accent", selection: $appearance.appAccentMode) {
                        Text("Orange (Default)").tag(0)
                        Text("Cyan").tag(1)
                        Text("Yellow").tag(2)
                        Text("Custom").tag(3)
                    }
                    HStack {
                        Button("Cycle Accent") {
                            appearance.appAccentMode = appearance.appAccentMode >= 2 ? 0 : (appearance.appAccentMode + 1)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(appearance.appAccentColor)
                        if appearance.appAccentMode == 3 {
                            ColorPicker("Any Color", selection: $customColor)
                                .labelsHidden()
                        }
                    }
                } header: {
                    HeaderLabel("Accent Color", symbol: "paintbrush")
                } footer: {
                    Text("Custom colors cannot be ultra white or ultra black.")
                }

                Section {
                    Toggle("Haptics", isOn: $appearance.appHaptics)
                    Toggle("Reduce Motion", isOn: $appearance.reduceMotion)
                    Toggle("Compact Home Layout", isOn: $appearance.compactHome)
                    Toggle("Glass Borders", isOn: $appearance.glassBorders)
                    Toggle("High Contrast Text", isOn: $appearance.highContrast)
                    Toggle("Fast Animations", isOn: $appearance.fastAnimations)
                } header: {
                    HeaderLabel("Behavior", symbol: "slider.horizontal.3")
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(UIColor.systemBackground))
            .navigationTitle("Appearance")
            .onChange(of: customColor) { _, newValue in
                let components = UIColor(newValue).cgColor.components ?? [0, 0, 0, 1]
                let red = components.count > 0 ? components[0] : 0
                let green = components.count > 1 ? components[1] : 0
                let blue = components.count > 2 ? components[2] : 0
                guard red > 0.05 && red < 0.95 &&
                      green > 0.05 && green < 0.95 &&
                      blue > 0.05 && blue < 0.95 else {
                    return
                }
                appearance.appAccentRed = red
                appearance.appAccentGreen = green
                appearance.appAccentBlue = blue
                appearance.appAccentMode = 3
            }
        }
    }
}

#Preview {
    AppearanceView()
        .environmentObject(AppearanceStore.shared)
}

