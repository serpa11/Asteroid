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

    var body: some View {
        NavigationStack {
            List {
                Section {
                    Toggle("Classic Apple Intelligence", isOn: $mgClassicIntell)
                        appAccentColor()
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
                        appAccentColor()
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
                                    appAccentColor()
                                    .padding(.top, 4)
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
            store.mgSetSiriAIEnabled(false, spoof: mgSiriAISpoof)
            mgSiriAI = false
            mgClassicIntell = false
            store.cacheExtra.removeObject(forKey: "A62OafQ85EJAiiqKn4agtg")
            for key in ["xOJfWykLmQCc8lKlzMlrLA", "K/R1GfGfCkXvEhaPS2Vrng", "waGD2UTpntjbDXD1r3oALQ", "WXi7NQbOKnEX4vPQFeZAdQ", "PTQ+ABwag03BwO/CKvIK/A", "0AJUv/uYPsRiZNGpWJ7zfg", "h9jDsbgj7xIVeIQ8S3/X3Q", "oYicEKzVTz4/CxxE05pEgQ", "5pYKlGnYYBzGvAlIU8RjEQ", "h63QSdBCiT/z0WU6rdQv6Q", "yK+xavymRGZ3xWc1tb8XDg", "97JDvERpVwO+GHtthIh7hA"] {
                store.cacheExtra.removeObject(forKey: key)
            }
            if let data = try? PropertyListSerialization.data(fromPropertyList: store.mgCurrentDict, format: .binary, options: 0) {
                _ = mgWrite(data)
                Haptic.shared.play(.soft)
                Alertinator.shared.alert(title: "Asteroid", body: "Apple Intelligence and Siri AI were removed. Respring if needed.", actionLabel: "Respring", action: { mgr.shouldRespring = true })
            }
        }
    }

    private func tryInstallSiriApp() async {
        let candidatePaths = ["/Applications/Siri.app", "/System/Applications/Siri.app", "/System/Applications/Utilities/Siri.app"]
        let siriAppURL = candidatePaths.map { URL(fileURLWithPath: $0) }.first { FileManager.default.fileExists(atPath: $0.path) }

        Task { @MainActor in store.cacheExtra[MGKey.prodType] = "iPhone17,1" }
        store.mgSetSiriAIEnabled(true, spoof: "iPhone17,1")
        mgSiriAI = true
        siriInstallProgress = 0.1
        let outcome = await Task.detached(priority: .userInitiated) { () -> (Bool, String) in
            guard let siriAppURL = siriAppURL else {
                return (false, "No Siri app bundle was found in the expected system locations.")
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

            let uicachePath = "/usr/bin/uicache"
            if !installed && FileManager.default.fileExists(atPath: uicachePath) {
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
                        result += " uicache registered Siri.app."
                    } else {
                        result += " uicache exited status: \(status)."
                    }
                } else {
                    result += " uicache spawn failed: \(spawnResult)."
                }
                if let first { free(first) }
                if let second { free(second) }
                if let third { free(third) }
            }

            if let workspace = workspace {
                if workspace.responds(to: NSSelectorFromString("installApplication:withOptions:error:")),
                   let installer = workspace as? LSAppInstalling {
                    var error: NSError?
                    installed = installer.installApplication?(siriAppURL, withOptions: nil, error: &error) ?? false
                    if installed {
                        result += " The system accepted the Siri app installation request."
                    } else if let error = error {
                        result += " System response: \(error.localizedDescription)"
                    } else {
                        result += " The system declined the request, so the app was not registered."
                    }
                }
            } else {
                result += " The private installation workspace is unavailable."
            }

            result += " Registration status: \(installed ? "installed" : "not registered")."
            return (installed, result)
        }.value

        if outcome.0 {
            withAnimation(.linear(duration: 0.3)) {
                siriInstallProgress = 1
            }
            Alertinator.shared.alert(title: "Install Siri App", body: outcome.1)
            try? await Task.sleep(nanoseconds: 1_500_000_000)
        } else {
            siriInstallProgress = nil
            Alertinator.shared.alert(title: "Install Siri App", body: outcome.1)
        }
        siriInstallProgress = nil
    }

}
#Preview {
    SiriAIView()
}

