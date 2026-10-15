import SwiftUI


struct ContentView: View {
    @AppStorage("ogMachineName") var ogMachineName = ""
    @EnvironmentObject var mgr: AsteroidManager
    @State private var showSettings = false
    @State private var checkedPersistence = false

    var body: some View {
        NavigationStack {
            GestaltView(title: "Home", showSiriEligibility: true, showHardwareDynamicIsland: true, showDeviceSpoofing: true, showArtworkSubtype: true)
                .environmentObject(mgr)
                .sheet(isPresented: $showSettings) {
                    SettingsView()
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Respring") {
                            mgr.shouldRespring = true
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            showSettings = true
                        } label: {
                            Label("Settings", systemImage: "gear")
                                .labelStyle(.iconOnly)
                        }
                    }
                }
                .onAppear {
                    if ogMachineName.isEmpty {
                        ogMachineName = machineName()
                    }
                    if !checkedPersistence {
                        checkedPersistence = true
                        _ = mgRestorePersistedChangesIfNeeded()
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
