//
//  ContentView.swift
//  Asteroid
//
//  Created by lunginspector on 8/14/26.
//

import SwiftUI


struct ContentView: View {
    @AppStorage("ogMachineName") var ogMachineName = ""
    @EnvironmentObject var mgr: AsteroidManager
    @State private var showSettings = false
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    LogView()
                        .modifier(TerminalPlatter())
                } header: {
                    HeaderLabel("Logs", symbol: "apple.terminal")
                }
                
                Section {
                    Button("Respring") {
                        mgr.shouldRespring = true
                    }
                } header: {
                    HeaderLabel("Actions", symbol: "gearshape")
                }

                Section {
                    NavigationLink(destination: GestaltView(title: "Home Gestalt Tweaks", showSiriEligibility: false, showHardwareDynamicIsland: false).environmentObject(mgr)) {
                        Text("Home Gestalt Tweaks")
                    }
                } header: {
                    HeaderLabel("Gestalt", symbol: "gearshape")
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.black)
            .navigationTitle("Asteroid")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showSettings = true
                    } label: {
                        Label("Settings", systemImage: "gear")
                            .labelStyle(.iconOnly)
                    }
                }
            }
            .sheet(isPresented: $showSettings) {
                SettingsView()
            }
            .onAppear {
                if ogMachineName.isEmpty {
                    ogMachineName = machineName()
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
