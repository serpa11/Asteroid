//
//  SettingsView.swift
//  Asteroid
//
//  Created by lunginspector on 8/20/26.
//

import SwiftUI

struct SettingsView: View {
    @AppStorage("homeLayout") private var homeLayout = 0
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
                } header: {
                    HeaderLabel("Credits", symbol: "star")
                }

            }
            .scrollContentBackground(.hidden)
            .background(Color.black)
                Section {
                    Picker("Home Layout", selection: $homeLayout) {
                        Text("List").tag(0)
                        Text("3x3 Grid").tag(1)
                        Text("Large List").tag(2)
                    }
                } header: {
                    HeaderLabel("Home Layout", symbol: "square.grid.3x3")
                } footer: {
                    Text("Controls how the gestalt tweaks appear on Home.")
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
