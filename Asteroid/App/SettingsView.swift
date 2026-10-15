import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @AppStorage("autoRespring") var autoRespring = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle("Auto-Respring", isOn: $autoRespring)
                } header: {
                    HeaderLabel("App Settings", symbol: "gearshape")
                } footer: {
                    Text("Automatically resprings your device after applying a tweak.")
                }

                Section {
                    AppInfoCell(build: AppInfo.appBuild)
                } header: {
                    HeaderLabel("About", symbol: "info.circle")
                } footer: {
                    Text("Asteroid")
                }

                Section {
                    LinkCreditCell(image: Image("serpa11"), name: "serpa11", description: "Developer.", url: "https://github.com/serpa11")
                    LinkCreditCell(image: Image("Skylo"), name: "Skylo", description: "The coolest and best person.", url: "https://x.com/heyskylo")
                    LinkCreditCell(image: Image("Gregoirus"), name: "Gregoirus", description: "my Long Lost Twin :>", url: "https://gregtube.lovable.app")
                } header: {
                    HeaderLabel("Credits", symbol: "star")
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(UIColor.systemBackground))
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        ToolbarLabel("Close", symbol: "xmark")
                    }
                }
            }
        }
    }
}
