//
//  ContentView.swift
//  Asteroid
//
//  Created by lunginspector on 8/14/26.
//

import SwiftUI


struct ContentView: View {
    @AppStorage("ogMachineName") var ogMachineName = ""
    @AppStorage("homeLayout") var homeLayout = 0
    @EnvironmentObject var mgr: AsteroidManager
    @State private var showSettings = false
    
    @ViewBuilder
    var homeContent: some View {
        let items = ["SRD", "PWM", "Camera", "Action", "Tap", "Stage", "iPadOS", "Internal", "Apply"]
        if homeLayout == 1 {
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(items, id: \.self) { item in
                        NavigationLink(destination: GestaltView(title: item, showSiriEligibility: false, showHardwareDynamicIsland: false, showDeviceSpoofing: false, showArtworkSubtype: false).environmentObject(mgr)) {
                            HomeGridCard(title: item)
                        }
                    }
                }
                .padding()
            }
        } else {
            GestaltView(title: "Home", showSiriEligibility: false, showHardwareDynamicIsland: false, showDeviceSpoofing: false, showArtworkSubtype: false)
                .environmentObject(mgr)
                .listStyle(homeLayout == 2 ? .grouped : .automatic)
        }
    }

    var body: some View {
        return NavigationStack {
            homeContent
            .scrollContentBackground(.hidden)
            .background(Color.black)
            .navigationTitle("Home")
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

struct HomeGridCard: View {
    let title: String
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: "square.grid.2x2")
                .font(.title3)
                .foregroundStyle(Color.orange)
            Text(title)
                .font(.caption)
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, minHeight: 90)
        .background(Color.black.opacity(0.65), in: .rect(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).stroke(Color.orange.opacity(0.35)))
    }
}
