import SwiftUI
import UniformTypeIdentifiers
import CoreServices
import Darwin

@objc protocol LSAppInstalling {
    @objc optional func installApplication(_ application: URL, withOptions: NSDictionary?, error: UnsafeMutablePointer<NSError?>?) -> Bool
}

struct SiriAIView: View {
    @EnvironmentObject private var mgr: AsteroidManager
    @StateObject private var store = GestaltStore.shared
    @AppStorage("mgSiriAI") private var mgSiriAI = false
    @AppStorage("mgSiriAISpoof") private var mgSiriAISpoof = "iPhone17,1"
    @State private var mgClassicIntell = false
    @Environment(\.colorScheme) private var colorScheme
    @State private var siriInstallProgress: Double?
    @State private var siriInstallError: String?
    @State private var siriInstallSucceeded = false

        Task { @MainActor in
            store.cacheExtra[MGKey.prodType] = "iPhone17,1"
        }
        store.mgSetSiriAIEnabled(true, spoof: "iPhone17,1")
        mgSiriAI = true

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
                                Task { await tryInstallSiriApp() }
                            }
                            .buttonStyle(ConfirmButtonStyle())
                            .disabled(siriInstallProgress != nil)

                            if let progress = siriInstallProgress {
                                ProgressView(value: progress)
                                    .progressViewStyle(.linear)
                                    .tint(.orange)
                                    .padding(.top, 4)
                                if let error = siriInstallError {
                                    HStack(alignment: .top, spacing: 6) {
                                        Image(systemName: "exclamationmark.triangle.fill")
                                            .foregroundStyle(.red)
                                        Text(error)
                                            .font(.footnote)
                                            .foregroundStyle(.red)
                                    }
                                    .padding(.top, 2)
                                }
                                if siriInstallSucceeded {
                                    HStack(spacing: 10) {
                                        Button("Open") {
                                            openApp(withBID: SysBID.siri)
                                        }
                                        .buttonStyle(.borderedProminent)
                                        .tint(.orange)
                                        .foregroundStyle(.white)

                                        Button("Uninstall Siri App") {
                                            // iOS does not expose safe removal APIs to third-party apps.
                                        }
                                        .buttonStyle(.glass)
                                        .tint(.orange)
                                        .foregroundStyle(.orange)
                                    }
                                    .padding(.top, 6)
                                }
                            }
                        }
                    }
                } header: {
                    HeaderLabel("Install Siri App", symbol: "app.badge")
                }

                Section {
                    HStack(alignment: .top, spacing: 12) {
                        Image(colorScheme == .dark ? "Siri_29_2025_dark" : "Siri_29_2025")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 56, height: 56)
                            .clipShape(RoundedRectangle(cornerRadius: 14, style: .continuous))

                        VStack(alignment: .leading, spacing: 8) {
                            Text("Revert back to Old Siri pre-Apple Intelligence")
                                .font(.headline)
                            Text("This will disable Apple Intelligence and Siri AI on your modern iPhone. To restore them, enable Classic Apple Intelligence from the options above.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            Button("Revert now") {
                                revertToOldSiri()
                            }
                            .buttonStyle(ConfirmButtonStyle())
                        }
                    }
                } header: {
                    HeaderLabel("Revert to Old Siri", symbol: "arrow.uturn.backward.circle")
                }

                Section {
                    Button("Apply MobileGestalt Changes") {
                        let result = store.mgSafelyApplySiriAIChange(enabled: mgSiriAI, spoof: mgSiriAISpoof)
                        if result.succeeded {
                            Haptic.shared.play(.soft)
                            Alertinator.shared.alert(title: "Asteroid", body: result.message + " Respring if needed.", actionLabel: "Respring", action: { mgr.shouldRespring = true })
                        } else {
                            Alertinator.shared.alert(title: "Failed to apply MobileGestalt!", body: result.message)
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

    private func revertToOldSiri() {
        Task { @MainActor in
            mgSiriAI = false
            mgClassicIntell = false
            let result = store.mgSafelyApplySiriAIChange(enabled: false, spoof: mgSiriAISpoof)
            if result.succeeded {
                Haptic.shared.play(.soft)
                Alertinator.shared.alert(title: "Asteroid", body: result.message + " Respring if needed.", actionLabel: "Respring", action: { mgr.shouldRespring = true })
            } else {
                Alertinator.shared.alert(title: "Failed to remove Siri AI!", body: result.message)
            }
        }
    }

    private func tryInstallSiriApp() async {
        await MainActor.run {
            siriInstallProgress = 0.1
            siriInstallError = nil
            siriInstallSucceeded = false
        }

        let result = await Task.detached(priority: .userInitiated) { () -> (Bool, String) in
            let candidatePaths = ["/Applications/Siri.app", "/System/Applications/Siri.app", "/System/Applications/Utilities/Siri.app"]
            guard let siriAppURL = candidatePaths.map({ URL(fileURLWithPath: $0) }).first(where: { FileManager.default.fileExists(atPath: $0.path) }) else {
                return (false, "No Siri app bundle was found in the expected system locations.")
            }

            var outcome = "Found \(siriAppURL.path). The installation request was attempted."
            var installed = false
            let uicachePath = "/usr/bin/uicache"
            if FileManager.default.fileExists(atPath: uicachePath) {
                let first = strdup(uicachePath)
                let second = strdup("-p")
                let third = strdup(siriAppURL.path)
                var argv: [UnsafeMutablePointer<CChar>?] = [first, second, third, nil]
                var pid: pid_t = 0
                let spawnResult = posix_spawn(&pid, uicachePath, nil, nil, &argv, nil)
                if spawnResult == 0 {
                    var status: Int32 = 0
                    waitpid(pid, &status, 0)
                    if status == 0 {
                        installed = true
                        outcome += " uicache registered Siri.app."
                    } else {
                        outcome += " uicache exited status: \(status)."
                    }
                } else {
                    outcome += " uicache spawn failed: \(spawnResult)."
                }
                if let first { free(first) }
                if let second { free(second) }
                if let third { free(third) }
            }

            let selectorNames = ["defaultWorkspace", "sharedWorkspace"]
            var workspace: AnyObject?
            for name in selectorNames {
                guard let klass = NSClassFromString("LSApplicationWorkspace") as? NSObject.Type,
                      klass.responds(to: NSSelectorFromString(name)) else { continue }
                workspace = klass.perform(NSSelectorFromString(name))?.takeUnretainedValue()
                if workspace != nil { break }
            }

            if let workspace = workspace, workspace.responds(to: NSSelectorFromString("installApplication:withOptions:error:")),
               let installer = workspace as? LSAppInstalling {
                var error: NSError?
                let systemInstalled = installer.installApplication?(siriAppURL, withOptions: nil, error: &error) ?? false
                if systemInstalled {
                    installed = true
                    outcome += " The system accepted the Siri app installation request."
                } else if let error = error {
                    outcome += " System response: \(error.localizedDescription)"
                } else {
                    outcome += " The system declined the request, so the app was not registered."
                }
            } else {
                outcome += " The private installation workspace is unavailable."
            }

            let detail = installed ? "not registered" : "not registered"
            outcome += " Registration status: \(installed ? "installed" : detail)."
            return (installed, outcome)
        }.value

        await MainActor.run {
            withAnimation(.linear(duration: 0.25)) {
                siriInstallProgress = 1
            }
            if result.0 {
                siriInstallSucceeded = true
                siriInstallError = nil
            } else {
                siriInstallSucceeded = false
                siriInstallError = result.1
            }
        }
    }
}
