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
                } header: {
                    HeaderLabel("Credits", symbol: "star")
                }
                
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
