import SwiftUI


struct ContentView: View {
    @AppStorage("ogMachineName") var ogMachineName = ""
    @EnvironmentObject var mgr: AsteroidManager
    @State private var showSettings = false
    @State private var showLogs = false

    var body: some View {
        NavigationStack {
            GestaltView(title: "Home", showSiriEligibility: true, showHardwareDynamicIsland: true, showDeviceSpoofing: true, showArtworkSubtype: true)
                .environmentObject(mgr)
                .safeAreaInset(edge: .bottom) {
                    MGControlBar(showLogs: $showLogs)
                }
                .sheet(isPresented: $showSettings) {
                    SettingsView()
                }
                .sheet(isPresented: $showLogs) {
                    NavigationStack {
                        LogView()
                            .navigationTitle("Logs")
                            .toolbar {
                                ToolbarItem(placement: .topBarTrailing) {
                                    Button {
                                        showLogs = false
                                    } label: {
                                        ToolbarLabel("Close", symbol: "xmark")
                                    }
                                }
                            }
                    }
                }
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button("Respring") {
                            mgr.requestRespring()
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
                    // The restore itself runs in AsteroidApp.init(), before any
                    // view reads MobileGestalt; here we only surface failures.
                    if let warning = mgr.pendingRestoreWarning {
                        mgr.pendingRestoreWarning = nil
                        Alertinator.shared.alert(title: "Couldn't restore your tweaks", body: warning)
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
