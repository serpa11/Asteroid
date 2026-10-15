import SwiftUI

struct DynamicIslandView: View {
    @EnvironmentObject private var mgr: AsteroidManager
    @StateObject private var store = GestaltStore.shared
    @State private var mgSubtype = 0
    @State private var mgEnableDeviceName = false
    @AppStorage("mgDeviceName") private var mgDeviceName = ""
    @State private var showCustomNames = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack {
                        Picker("Subtype", selection: $mgSubtype) {
                            Text("iPhone 14 Pro").tag(2436)
                            Text("iPhone 14 Pro Max").tag(2796)
                            Text("iPhone 15 Pro Max").tag(2976)
                            if #available(iOS 17.0, *) {
                                Text("iPhone 16 Pro").tag(2622)
                                Text("iPhone 16 Pro Max").tag(2868)
                                Text("iPhone 18 Pro").tag(2738)
                            }
                            Text("Original").tag(mgSubtype)
                        }
                        Spacer()
                    }
                } header: {
                    HeaderLabel("Artwork", symbol: "paintbrush")
                }

                Section {
                    PlainToggle("Enable Dynamic Island", icon: "", isOn: store.mgKeyBinding([MGKey.island]))
                } header: {
                    HeaderLabel("Dynamic Island", symbol: "airplane")
                } footer: {
                    Text("Controls the Dynamic Island capability and its placement.")
                }

                Section {
                    Button("Apply MobileGestalt Changes") {
                        if let data = try? PropertyListSerialization.data(fromPropertyList: store.mgCurrentDict, format: .binary, options: 0) {
                            let res = mgWrite(data)
                            if res {
                                Haptic.shared.play(.soft)
                                Alertinator.shared.alert(title: "Asteroid", body: "MobileGestalt was updated. Respring if needed.", actionLabel: "Respring", action: { mgr.shouldRespring = true })
                            } else {
                                Alertinator.shared.alert(title: "Failed to apply MobileGestalt!", body: "Overwrite failed.")
                            }
                        }
                    }
                    .buttonStyle(ConfirmButtonStyle())
                }
            }
            .navigationTitle("Dynamic Island")
            .scrollContentBackground(.hidden)
            .background(Color(UIColor.systemBackground))
            .onAppear {
                guard let dict = NSMutableDictionary(contentsOf: MGURL.fsGestaltURL) else { return }
                store.mgCurrentDict = dict
                if let cacheExtra = dict["CacheExtra"] as? NSDictionary,
                   let artwork = cacheExtra[MGKey.artwork] as? NSDictionary {
                    mgSubtype = artwork["ArtworkDeviceSubType"] as? Int ?? 0
                    if let name = artwork["ArtworkDeviceProductDescription"] as? String {
                        mgDeviceName = name
                    }
                }
            }
        }
    }
}
