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
            .background(Color(UIColor.systemBackground))
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
        let candidatePaths = ["/Applications/Siri.app", "/System/Applications/Siri.app", "/System/Applications/Utilities/Siri.app"]
        let siriAppURL = candidatePaths.map { URL(fileURLWithPath: $0) }.first { FileManager.default.fileExists(atPath: $0.path) }
        Task.detached(priority: .userInitiated) {
            guard let siriAppURL else {
                await MainActor.run {
                    Alertinator.shared.alert(title: "Install Siri App", body: "No Siri app bundle was found in the expected system locations.")
                }
                return
            }

            var result = "Found \(siriAppURL.path). The installation request was attempted."
            let selectorNames = ["defaultWorkspace", "sharedWorkspace"]
            var workspace: AnyObject?
            for name in selectorNames {
                guard let klass = NSClassFromString("LSApplicationWorkspace") as? NSObject.Type,
                      klass.responds(to: NSSelectorFromString(name)) else { continue }
                workspace = klass.perform(NSSelectorFromString(name))?.takeUnretainedValue()
                if workspace != nil { break }
            }

            var installed = false
            if let workspace,
               workspace.responds(to: NSSelectorFromString("installApplication:withOptions:error:")),
               let installer = workspace as? LSAppInstalling {
                var error: NSError?
                installed = installer.installApplication?(siriAppURL, withOptions: nil, error: &error) ?? false
                if installed {
                    result += " The system accepted the Siri app installation request."
                } else if let error {
                    result += " System response: \(error.localizedDescription)"
                } else {
                    result += " The system declined the request, so the app was not registered."
                }
            } else {
                result += " The private installation workspace is unavailable."
            }

            // A second concrete attempt: determine whether the bundle can at least be read/copied.
            let copyURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Siri.app")
            if let copyURL {
                try? FileManager.default.removeItem(at: copyURL)
                do {
                    if !FileManager.default.fileExists(atPath: copyURL.path) {
                        try FileManager.default.copyItem(at: siriAppURL, to: copyURL)
                    }
                    result += " Siri bundle data was accessible. Registration status: \(installed ? "installed" : "not registered")."
                } catch {
                    result += " Bundle access error: \(error.localizedDescription)"
                }
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
