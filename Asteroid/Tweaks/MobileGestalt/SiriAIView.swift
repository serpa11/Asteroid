import SwiftUI
import UniformTypeIdentifiers
import CoreServices

@objc protocol LSAppInstalling {
    @objc optional func installApplication(_ application: URL, withOptions: NSDictionary?, error: UnsafeMutablePointer<NSError?>?) -> Bool
}

struct SiriAIView: View {
    @StateObject private var store = GestaltStore.shared
    @AppStorage("mgSiriAI") private var mgSiriAI = false
    @AppStorage("mgSiriAISpoof") private var mgSiriAISpoof = "iPhone17,1"
    @State private var mgClassicIntell = false
    @Environment(\.colorScheme) private var colorScheme

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
                    Text("Enables Apple Intelligence, Siri AI eligibility, regional and assistant capability fields.")
                }

                Section {
                    HStack(alignment: .top, spacing: 12) {
                        Image(colorScheme == .dark ? "Siri_2026_dark" : "Siri_2026")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 56, height: 56)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Install Siri app on unsupported iPhone")
                                .font(.headline)
                            Text("This will try installing the Siri app on your unsupported iPhone. It is not expected to succeed.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            Button("Install now") {
                                tryInstallSiriApp()
                            }
                            .buttonStyle(ConfirmButtonStyle())
                        }
                    }
                } header: {
                    HeaderLabel("Install Siri App", symbol: "app.badge")
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

    private func tryInstallSiriApp() {
        let siriAppURL = URL(fileURLWithPath: "/Applications/Siri.app")
        Task.detached(priority: .userInitiated) {
            var result = "The Siri app installation request could not be completed."
            if FileManager.default.fileExists(atPath: siriAppURL.path) {
                let selectorNames = ["defaultWorkspace", "sharedWorkspace"]
                var workspace: AnyObject?
                for name in selectorNames {
                    guard let klass = NSClassFromString("LSApplicationWorkspace") as? NSObject.Type,
                          klass.responds(to: NSSelectorFromString(name)) else { continue }
                    workspace = klass.perform(NSSelectorFromString(name))?.takeUnretainedValue()
                    if workspace != nil { break }
                }

                if let workspace,
                   workspace.responds(to: NSSelectorFromString("installApplication:withOptions:error:")),
                   let installer = workspace as? LSAppInstalling {
                    var error: NSError?
                    let success = installer.installApplication?(siriAppURL, withOptions: nil, error: &error) ?? false
                    if success {
                        result = "Siri app installation request submitted."
                    } else if let error {
                        result = error.localizedDescription
                    } else {
                        result = "The system declined the Siri app installation request. It was not expected to succeed."
                    }
                } else {
                    result = "The installation API is unavailable. It was not expected to succeed."
                }
            } else {
                result = "No Siri app bundle was found at /Applications/Siri.app."
            }
            await MainActor.run {
                Alertinator.shared.alert(title: "Install Siri App", body: result)
            }
        }
    }
}

#Preview {
    SiriAIView()
}
