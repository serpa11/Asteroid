//
//  SettingsView.swift
//  Asteroid
//
//  Created by lunginspector on 8/20/26.
//

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
                    AppInfoCell(build: build)
                } header: {
                    HeaderLabel("About", symbol: "info.circle")
                } footer: {
                    Text("Asteroid")
                }

                Section {
                    LinkCreditCell(image: Image("serpa11"), name: "serpa11", description: "Developer.", url: "https://github.com/serpa11")
                    LinkCreditCell(image: Image("Skylo"), name: "Skylo", description: "The coolest and best person.", url: "https://x.com/heyskylo")
                    LinkCreditCell(image: Image("lunginspector"), name: "lunginspector", description: "Original Erosion UI author.", url: "https://github.com/lunginspector")
                } header: {
                    HeaderLabel("Credits", symbol: "star")
                }

            }
                Section {
                    Text("Enables the all new Siri AI beta from iOS 27 release in WWDC26 by Apple, if it does not work it means you may need to report the bug in our github so we can try fixing it as soon as possible.")
                    Button("Try New Siri AI (Beta)") {
                        GestaltStore.shared.mgSetSiriAIEnabled(true, spoof: "iPhone18,4")
                        Alertinator.shared.alert(title: "Siri AI", body: "Siri AI beta spoof applied. Respring or reboot if needed.", showCancel: false, actionLabel: "OK", action: {})
                    }
                } header: {
                    HeaderLabel("Siri AI Beta", symbol: "apple.intelligence")
                }

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
