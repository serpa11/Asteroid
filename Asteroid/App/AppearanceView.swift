import SwiftUI

struct AppearanceView: View {
    @AppStorage("preferredColorScheme") private var preferredColorScheme = 0
    @AppStorage("appHaptics") private var appHaptics = true
    @AppStorage("compactHome") private var compactHome = false
    @AppStorage("reduceMotion") private var reduceMotion = false

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
                    Toggle("Haptics", isOn: $appHaptics)
                    Toggle("Reduce Motion", isOn: $reduceMotion)
                    Toggle("Compact Home Layout", isOn: $compactHome)
                } header: {
                    HeaderLabel("Behavior", symbol: "slider.horizontal.3")
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(UIColor.systemBackground))
            .navigationTitle("Appearance")
        }
    }
}

#Preview {
    AppearanceView()
}
