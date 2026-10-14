import SwiftUI


struct ContentView: View {
    @AppStorage("ogMachineName") var ogMachineName = ""
    @EnvironmentObject var mgr: AsteroidManager
    @State private var showSettings = false

    var body: some View {
        NavigationStack {
            GestaltView(title: "Home", showSiriEligibility: false, showHardwareDynamicIsland: false, showDeviceSpoofing: false, showArtworkSubtype: false)
                .environmentObject(mgr)
                .sheet(isPresented: $showSettings) {
                    SettingsView()
                }
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
