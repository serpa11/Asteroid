import SwiftUI
import UniformTypeIdentifiers

struct SiriAIView: View {
    @StateObject private var store = GestaltStore.shared
    @AppStorage("mgSiriAI") private var mgSiriAI = false
    @AppStorage("mgSiriAISpoof") private var mgSiriAISpoof = "iPhone17,1"
    @State private var mgClassicIntell = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle("Classic Apple Intelligence", isOn: $mgClassicIntell)
                        .tint(.orange)
                        .onChange(of: mgClassicIntell) { (_, newValue) in
                            if newValue {
                                mgSiriAI = false
                                store.mgSetSiriAIEnabled(false, spoof: mgSiriAISpoof)
                                store.cacheExtra["A62OafQ85EJAiiqKn4agtg"] = 1
                            } else if !mgSiriAI {
                                store.cacheExtra.removeObject(forKey: "A62OafQ85EJAiiqKn4agtg")
                            }
                        }
                    Toggle("Siri AI (Beta)", isOn: $mgSiriAI)
                        .tint(.orange)
                        .onChange(of: mgSiriAI) { (_, newValue) in
                            if newValue {
                                mgClassicIntell = false
                                store.mgSetSiriAIEnabled(true, spoof: mgSiriAISpoof)
                            } else {
                                store.mgSetSiriAIEnabled(false, spoof: mgSiriAISpoof)
                            }
                        }
                    if mgSiriAI {
                        Picker("Siri AI Spoofing", selection: $mgSiriAISpoof) {
                            Text("iPhone 16 Pro").tag("iPhone17,1")
                            Text("iPhone 16 Pro Max").tag("iPhone17,2")
                            Text("iPhone 17 Pro").tag("iPhone18,1")
                            Text("iPhone 17 Pro Max").tag("iPhone18,2")
                            Text("iPhone Air").tag("iPhone18,4")
                        }
                        .onChange(of: mgSiriAISpoof) { (_, newValue) in
                            if mgSiriAI {
                                store.mgSetSiriAIProfile(newValue)
                            }
                        }
                    }
                } header: {
                    HeaderLabel("Siri Eligibility", symbol: "apple.intelligence")
                } footer: {
                    Text("Enables the Apple Intelligence modes associated with Siri and iOS 27 features.")
                }
                Section {
                    Button("Apply MobileGestalt Changes") {
                        if let data = try? PropertyListSerialization.data(fromPropertyList: store.mgCurrentDict, format: .binary, options: 0) {
                            _ = mgWrite(data)
                            Alertinator.shared.alert(title: "Asteroid", body: "MobileGestalt was updated. Respring if needed.")
                        }
                    }
                    .buttonStyle(ConfirmButtonStyle())
                }
            }
            .navigationTitle("Siri AI")
            .scrollContentBackground(.hidden)
            .background(Color.black)
            .onAppear {
                if let dict = NSMutableDictionary(contentsOf: MGURL.fsGestaltURL) {
                    store.mgCurrentDict = dict
                }
                mgSiriAI = store.strVal(forKey: "h63QSdBCiT/z0WU6rdQv6Q") == "LL"
                    && store.cacheExtra["A62OafQ85EJAiiqKn4agtg"] as? Int == 1
                mgClassicIntell = !mgSiriAI && (store.cacheExtra["A62OafQ85EJAiiqKn4agtg"] as? Int == 1)
            }
        }
    }
}
