import SwiftUI

func appAccentColor() -> Color {
    let mode = UserDefaults.standard.integer(forKey: "appAccentMode")
    switch mode {
    case 1: return .cyan
    case 2: return .yellow
    case 3:
        let red = UserDefaults.standard.double(forKey: "appAccentRed")
        let green = UserDefaults.standard.double(forKey: "appAccentGreen")
        let blue = UserDefaults.standard.double(forKey: "appAccentBlue")
        if red > 0.95 || green > 0.95 || blue > 0.95 ||
           red < 0.05 || green < 0.05 || blue < 0.05 {
            return .orange
        }
        return Color(red: red, green: green, blue: blue)
    default:
        return .orange
    }
}

struct AppearanceView: View {
    @AppStorage("preferredColorScheme") private var preferredColorScheme = 0
    @AppStorage("appHaptics") private var appHaptics = true
    @AppStorage("compactHome") private var compactHome = false
    @AppStorage("reduceMotion") private var reduceMotion = false
    @AppStorage("highContrast") private var highContrast = false
    @AppStorage("glassBorders") private var glassBorders = true
    @AppStorage("fastAnimations") private var fastAnimations = false
    @AppStorage("appAccentMode") private var appAccentMode = 0
    @State private var customColor = appAccentColor()

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Picker("Appearance", selection: $preferredColorScheme) {
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
                    Picker("Accent", selection: $appAccentMode) {
                        Text("Orange (Default)").tag(0)
                        Text("Cyan").tag(1)
                        Text("Yellow").tag(2)
                        Text("Custom").tag(3)
                    }
                    HStack {
                        Button("Cycle Accent") {
                            appAccentMode = appAccentMode == 2 ? 3 : (appAccentMode + 1)
                            if appAccentMode == 3 { appAccentMode = 0 }
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(appAccentColor())
                        if appAccentMode == 3 {
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
                    Toggle("Haptics", isOn: $appHaptics)
                    Toggle("Reduce Motion", isOn: $reduceMotion)
                    Toggle("Compact Home Layout", isOn: $compactHome)
                    Toggle("Glass Borders", isOn: $glassBorders)
                    Toggle("High Contrast Text", isOn: $highContrast)
                    Toggle("Fast Animations", isOn: $fastAnimations)
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
                UserDefaults.standard.set(red, forKey: "appAccentRed")
                UserDefaults.standard.set(green, forKey: "appAccentGreen")
                UserDefaults.standard.set(blue, forKey: "appAccentBlue")
                appAccentMode = 3
            }
        }
    }
}

#Preview {
    AppearanceView()
}
