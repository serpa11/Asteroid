//
//  GestaltView.swift
//  Asteroid
//
//  Created by lunginspector on 8/14/26.
//

import SwiftUI

import Combine

import UniformTypeIdentifiers

struct GestaltView: View {
    var title: String = "More MobileGestalt Tweaks"
    var showSiriEligibility: Bool = true
    var showHardwareDynamicIsland: Bool = true
    var showDeviceSpoofing: Bool = true
    var showArtworkSubtype: Bool = true
    @EnvironmentObject private var mgr: AsteroidManager
    @StateObject private var store = GestaltStore.shared
    @AppStorage("mgOverrideGates") private var mgOverrideGates = false
    @AppStorage("mgWriteAtomically") private var mgWriteAtomically = true
    @AppStorage("autoRespring") var autoRespring = false
    @AppStorage("compactHome") private var compactHome = false
    @AppStorage("hasShownSheet") private var hasShownSheet = false
    @Environment(\.dismiss) private var dismiss
    
    @State private var mgSubtype = 0
    @State private var mgOgSubtype = 0
    @State private var mgOgDeviceName = ""
    @State private var mgEnableDeviceName = false
    @AppStorage("mgDeviceName") private var mgDeviceName = ""
    @AppStorage("ogMachineName") private var ogMachineName = ""
    @AppStorage("showRegionTweak") private var showRegionTweak = false
    @AppStorage("showCustomKeys") private var showCustomKeys = false
    @AppStorage("mgCustKeyArray") var customKeys: [MGCustomKey] = []
    @State private var mgProductType = ""
    @State private var mgClassicIntell = false
    // iPhone Duo Mode is reported straight from MobileGestalt in onAppear so
    // it always reflects what is really saved on disk.
    @State private var mgDuoMode = false
    
    @State private var showInfoSheet = false
    @State private var idiotButtonTimerComplete = false

    // Artwork subtypes that belong to an island-equipped iPhone. Picking one
    // of these always switches the Dynamic Island on when Apply is pressed,
    // while keeping the subtype you actually picked (the iPhone 16 Pro
    // subtype enables the island, but never turns into the 18 Pro subtype).
    private let islandSubtypes: Set<Int> = [2796, 2976, 2622, 2868, 2736, 2738, 2034]

    // iPhone Duo (iPhone19,4 / A3447 / V68AP / t8160) — Apple's foldable.
    private enum Duo {
        static let productType = "iPhone19,4"
        static let subtype = 2034
        static let hwModel = "V68AP"     // oYicEKzVTz4/CxxE05pEgQ
        static let platform = "t8160"    // 5pYKlGnYYBzGvAlIU8RjEQ
        static let modelNumber = "A3447" // 97JDvERpVwO+GHtthIh7hA
    }
    
    var body: some View {
        NavigationStack {
            List {
                Section {
                    if showArtworkSubtype {
                    HStack {
                        Picker("Subtype", selection: $mgSubtype) {
                            Text("Original (\(mgOgSubtype))").tag(mgOgSubtype)
                            if isDynamIslandHD() && doubleSysVrs() < 19.0 {
                                Text("Disable Dynamic Island").tag(2436)
                            }
                            Text("iPhone 14 Pro").tag(2436)
                            Text("iPhone 14 Pro Max").tag(2796)
                            Text("iPhone 15 Pro Max").tag(2976)
                            if doubleSysVrs() >= 18.0 {
                                Text("iPhone 16 Pro").tag(2622)
                                Text("iPhone 16 Pro Max").tag(2868)
                            }
                            if doubleSysVrs() >= 26.0 {
                                Text("iPhone Air").tag(2736)
                                Text("iPhone 18 Pro").tag(2738)
                            }
                            if isHomeButtonHD() {
                                Text("iPhone X Gestures").tag(2436)
                            }
                        }
                    Spacer()
                        Button {
                            Alertinator.shared.alert(title: "Subtype Info", body: MGMsg.subtype)
                        } label: {
                            Image(systemName: "info.circle")
                                .frame(width: 24, height: 22)
                        }
                        .buttonStyle(.plain)
                    }
                    }
                    Toggle("Custom Device Name", isOn: $mgEnableDeviceName)
                    if mgEnableDeviceName {
                        TextField("Device Name", text: $mgDeviceName)
                    }
                } header: {
                    HeaderLabel("Custom", symbol: "fan")
                }
                
                if showHardwareDynamicIsland && (!isDynamIslandHD() || !isAODHD() || !isBootChimeHD() || !isChargeLimitHD() || mgOverrideGates) {
                    Section {
                        if showHardwareDynamicIsland && (!isDynamIslandHD() || mgOverrideGates) {
                            PlainToggle("Enable Dynamic Island", minVrs: 19.0, isOn: store.mgKeyBinding([MGKey.island]))
                        }
                        if !isDynamIslandHD() || mgOverrideGates {
                            PlainToggle("Enable Vertical Face ID", minVrs: 18.0, isOn: store.mgKeyBinding([MGKey.verticalFaceID]))
                        }
                        if !isAODHD() || mgOverrideGates {
                            PlainToggle("Enable AOD", minVrs: 18.0, isOn: store.mgKeyBinding([MGKey.AOD, MGKey.AOTime]))
                            if store.isEnabled([MGKey.AOD]) {
                                PlainToggle("Enable AOD Vibrancy", minVrs: 18.0, isOn: store.mgKeyBinding([MGKey.AODVibrancy]))
                            }
                        }
                        if !isChargeLimitHD() || mgOverrideGates {
                            PlainToggle("Enable Charge Limit", minVrs: 17.0, isOn: store.mgKeyBinding([MGKey.chargeLim]))
                        }
                        if !isBootChimeHD() || mgOverrideGates {
                            PlainToggle("Enable Boot Chime", isOn: store.mgKeyBinding([MGKey.bootChime]))
                        }
                    } header: {
                        HeaderLabel("Hardware Features", symbol: "gearshape")
                    }
                }
                
                Section {
                    PlainToggle("Enable SRD UI", minVrs: 26.0, isOn: store.mgKeyBinding([MGKey.srd]))
                    if showRegionTweak {
                        PlainToggle("Disable Region Restrictions", isOn: store.mgRegionRestrictionsBinding())
                    }
                    if showSiriEligibility && (!isAppleIntellHD() || mgOverrideGates) {
                        PlainToggle("Enable Apple Intelligence Classic", infoType: .warning, infoTitle: "Apple Intelligence Classic", infoMessage: "This is the classic Apple Intelligence toggle. Turning it on only sets the Apple Intelligence capability key - it no longer rewrites your ProductType, region or board keys behind your back. Press Apply to save.\n\nIf you don't want classic Apple Intelligence, leave this off or use \"Revert to Old Siri\" further down this page.", minVrs: 18.1, isOn: $mgClassicIntell)
                            .onChange(of: mgClassicIntell) { (_, newVal) in
                                // Only touch the Apple Intelligence key. The old
                                // code also called mgSetSiriAIEnabled(false),
                                // which deleted ProductType, region and board
                                // keys and destroyed the device spoof at the
                                // same time.
                                if newVal {
                                    store.cacheExtra[MGKey.appIntell] = 1
                                } else {
                                    store.cacheExtra.removeObject(forKey: MGKey.appIntell)
                                }
                                store.objectWillChange.send()
                            }
                    }
                    if showDeviceSpoofing {
                    HStack(spacing: 10) {
                        Picker("Spoofing", selection: $mgProductType) {
                            Text("Default").tag(ogMachineName)
                            if ogMachineName.contains("Pad") {
                                if doubleSysVrs() >= 17.4 {
                                    Text("iPad Pro 11-inch (M4)").tag("iPad16,3")
                                    Text("iPad Pro 11-inch (M4, Cellular)").tag("iPad16,4")
                                }
                                Text("iPad Pro 11-inch (4th Gen)").tag("iPad14,3")
                                Text("iPad Pro 11-inch (4th Gen, Cellular)").tag("iPad14,4")
                            } else {
                                Text("iPhone 15 Pro").tag("iPhone16,1")
                                Text("iPhone 15 Pro Max").tag("iPhone16,2")
                                if doubleSysVrs() >= 18.0 {
                                    Text("iPhone 16").tag("iPhone17,3")
                                    Text("iPhone 16 Plus").tag("iPhone17,4")
                                    Text("iPhone 16 Pro").tag("iPhone17,1")
                                    Text("iPhone 16 Pro Max").tag("iPhone17,2")
                                }
                                if doubleSysVrs() >= 19.0 {
                                    Text("iPhone 17").tag("iPhone18,3")
                                    Text("iPhone 17 Pro").tag("iPhone18,1")
                                    Text("iPhone 17 Pro Max").tag("iPhone18,2")
                                    Text("iPhone Air").tag("iPhone18,4")
                                }
                            }
                        }
                        Button {
                            Alertinator.shared.alert(title: "Device Spoofing Info", body: isAppleIntellHD() ? MGMsg.spoofUseless : MGMsg.spoofAI)
                        } label: {
                            Image(systemName: "info.circle")
                                .frame(width: 24, height: 22)
                        }
                        .buttonStyle(.plain)
                    }
                    }
                } header: {
                    HeaderLabel("Eligibility", symbol: "flag")
                }
                
                if showDeviceSpoofing {
                Section {
                    PlainToggle("iPhone Duo Mode", infoType: .warning, infoTitle: "iPhone Duo Mode", infoMessage: "Turns a normal iPhone into an iPhone Duo: ProductType is spoofed to iPhone19,4, the artwork subtype switches to the Duo's 2034, the Duo board keys (V68AP / t8160 / A3447) are written, and the Dynamic Island is switched on. Duo-only features that are gated behind the Duo subtype, such as Edge Light, unlock with it too.\n\nPress Apply, then respring. Spoofing your device model may break Face ID as well as other features.", isOn: $mgDuoMode)
                        .onChange(of: mgDuoMode) { (_, enabled) in
                            setDuoMode(enabled)
                        }
                } header: {
                    HeaderLabel("iPhone Duo", symbol: "rectangle.split.2x1")
                } footer: {
                    Text("Turn this off and press Apply to go back to your original device identity.")
                }
                }
                
                Section {
                    if !isCrashDectHD() || mgOverrideGates {
                        PlainToggle("Crash Detection", isOn: store.mgKeyBinding([MGKey.crashDet]))
                    }
                    if !isPWMHD() || mgOverrideGates {
                        PlainToggle("Pulse Width Modulation", minVrs: 19.0, isOn: store.mgKeyBinding([MGKey.pwm]))
                    }
                    if ogMachineName.contains("iPhone") || mgOverrideGates {
                        PlainToggle("Apple Pencil", isOn: store.mgKeyBinding([MGKey.appPencil]))
                            PlainToggle("Touch ID Settings", isOn: store.mgKeyBinding(["8Shl+AdVKo09f1Sldkb0kA"]))
                    }
                    if !isCamControlHD() || mgOverrideGates {
                        PlainToggle("Camera Control", minVrs: 18.0, isOn: store.mgKeyBinding([MGKey.camButton, MGKey.grapPefr]))
                    }
                    if !isActionButtonHD() || mgOverrideGates {
                        PlainToggle("Action Button", minVrs: 17.0, isOn: store.mgKeyBinding([MGKey.actButton]))
                    }
                    if isHomeButtonHD() || mgOverrideGates {
                        PlainToggle("Tap to Wake", isOn: store.mgKeyBinding([MGKey.tapToWake]))
                    }
                } header: {
                    HeaderLabel("Preference Bundles", symbol: "gear")
                }
                
                Section {
                    if machineName().contains("iPad") || mgOverrideGates {
                        PlainToggle("Enable Stage Manager", isOn: store.mgKeyBinding([MGKey.stageMgr]))
                    }
                    if store.strVal(forKey: MGKey.deviceClass) == "iPhone" || mgOverrideGates {
                        PlainToggle("Enable iPadOS UI", infoType: .none, infoMessage: MGMsg.ipadOS, isOn: store.mgTrollPadBinding())
                    }
                } header: {
                    HeaderLabel("iPadOS", symbol: "ipad")
                }

                Section {
                    PlainToggle("Revert to Old Siri", infoType: .info, infoTitle: "Revert to Old Siri", infoMessage: "Switches back to the original Siri by removing the Apple Intelligence and Siri AI capability keys. It is written to MobileGestalt immediately and only touches those keys - every other tweak is left exactly as it is.", isOn: revertToOldSiriBinding)
                } header: {
                    HeaderLabel("Revert to Old Siri", symbol: "arrow.uturn.backward.circle")
                } footer: {
                    Text("Turning this on applies immediately and offers a respring. Turning it off puts Apple Intelligence back; press Apply to save that.")
                }
            }
            .listRowSpacing(compactHome ? 4 : 10)
            .scrollContentBackground(.hidden)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Menu {
                        Button {
                            mgRevert()
                        } label: {
                            Label("Revert Tweaks", systemImage: "xmark")
                        }
                        
                        Button(role: .destructive) {
                            Alertinator.shared.alert(title: "Are you sure you'd like to reset MobileGestalt?", body: MGMsg.mgReset, actionLabel: "Confirm", action: {
                                do {
                                    try fm.removeItem(at: MGURL.savedGestaltURL)
                                    try fm.removeItem(at: MGURL.fsGestaltURL)
                                    // The saved tweaks must go too, otherwise the
                                    // next launch restores them straight over the
                                    // freshly regenerated MobileGestalt.
                                    try? fm.removeItem(at: MGURL.appliedGestaltURL)
                                    store.mgCurrentDict = NSMutableDictionary()
                                    Alertinator.shared.alert(title: "Successfully reset MobileGestalt!", body: MGMsg.mgResetComp, showCancel: false, actionLabel: "Exit App", action: { exitinator() })
                                } catch {
                                    print("(mg) failed to reset mobilegestalt: \(error.localizedDescription)")
                                    Alertinator.shared.alert(title: "Failed to reset MobileGestalt!", body: AppMsg.opFailed)
                                }
                            })
                        } label: {
                            Label("Reset Gestalt", systemImage: "trash")
                        }
                        
                        Divider()
                        
                        if showCustomKeys {
                            NavigationLink(destination: CustomKeyView()) {
                                Label("Custom Keys", systemImage: "pencil")
                            }
                        }
                        
                        // tweak-specific settings
                        NavigationLink {
                            List {
                                Section {
                                    Button("Export Current Gestalt") {
                                        presentShareSheet(with: MGURL.fsGestaltURL)
                                    }
                                    Button("Export Original Gestalt") {
                                        presentShareSheet(with: MGURL.savedGestaltURL)
                                    }
                                    Button("Reset Saved Gestalt", role: .destructive) {
                                        Alertinator.shared.alert(title: "Notice", body: MGMsg.mgResetSavWarn, action: {
                                            try? fm.removeItem(at: MGURL.savedGestaltURL)
                                            // The result used to be thrown away, so
                                            // the store and the toggles kept pointing
                                            // at the deleted snapshot.
                                            store.mgCurrentDict = mgLoadData()
                                            refreshStateFromStore()
                                        })
                                    }
                                } header: {
                                    HeaderLabel("Data", symbol: "loupe")
                                }
                                
                                Section {
                                    Toggle("Restore Tweaks on Launch", isOn: $mgWriteAtomically)
                                    Toggle("Show Custom Keys", isOn: $showCustomKeys)
                                } footer: {
                                    Text("Restore Tweaks on Launch re-applies your saved MobileGestalt the moment the app opens, before anything else reads it. That is what keeps your tweaks alive across a reboot or a respring.")
                                }
                            }
                            .scrollContentBackground(.hidden)
            .background(Color(UIColor.systemBackground))
            .navigationTitle("Gestalt Settings")
                        } label: {
                            Label("MobileGestalt Settings", systemImage: "gear")
                        }
                    } label: {
                        Label("Menu", systemImage: "ellipsis")
                            .labelStyle(.iconOnly)
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Apply", role: .adaptiveConfirm) {
                        if !hasShownSheet {
                            showInfoSheet = true
                        } else {
                            mgApply()
                        }
                    }
                }
            }
            .sheet(isPresented: $showInfoSheet) {
                NavigationStack {
                    VStack {
                        InfoSheet(title: "Before you begin...") {
                            InfoSheetCell(title: "Apple Intelligence (Classic)", symbol: "apple.intelligence", context: MGMsg.spoofAI)
                        } button: {
                            Button("Apply") {
                                showInfoSheet = false
                                hasShownSheet = true
                                idiotButtonTimerComplete = false
                                mgApply(isFromSheet: true)
                            }
                            .buttonStyle(ConfirmButtonStyle())
                            .padding(.horizontal, 30)
                            .padding(.bottom, device.userInterfaceIdiom == .pad ? 25 : 0)
                            .disabled(!idiotButtonTimerComplete)
                        }
                    }
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                            idiotButtonTimerComplete = true
                        }
                    }
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Cancel") {
                                showInfoSheet = false
                                idiotButtonTimerComplete = false
                            }
                        }
                    }
                }
            }
            .onAppear {
                store.mgCurrentDict = mgLoadData()
                refreshStateFromStore()
                let isWritable = fm.isWritableFile(atPath: MGURL.fsGestaltURL.path)
                if !isWritable {
                    let res = BadQuery().grantAccess(atPath: MGURL.fsGestaltURL.deletingLastPathComponent().path, toFileName: "com.apple.MobileGestalt.plist")
                    if !res.0 {
                        Alertinator.shared.alert(title: "Failed to get write access to MobileGestalt!", body: "Tweaks will NOT apply. \(res.2) Maybe try restarting the app?")
                    }
                }
            }
        }
    }
    
    // Re-syncs every toggle from the dictionary that is actually loaded, so the
    // screen can never show stale state after a restore, a revert or a respring.
    private func refreshStateFromStore() {
        mgClassicIntell = store.boolValue(forKey: MGKey.appIntell) == true
        mgDuoMode = mgProductType == Duo.productType
    }

    // "Revert to Old Siri" is the exact inverse of Apple Intelligence: it reads
    // as on whenever the Apple Intelligence capability key is missing.
    private var revertToOldSiriBinding: Binding<Bool> {
        Binding(get: { !mgClassicIntell }, set: { revert in
            if revert {
                mgRevertToOldSiriNow()
            } else {
                // Turning the revert off puts Apple Intelligence back in memory;
                // Apply is what writes it to MobileGestalt.
                mgClassicIntell = true
            }
        })
    }

    private func mgRevertToOldSiriNow() {
        let result = store.mgRevertToOldSiri()
        Haptic.shared.play(result.succeeded ? .soft : .heavy)
        // Always notify, so a failed attempt snaps the toggle back instead of
        // leaving it visually on while MobileGestalt is untouched.
        store.objectWillChange.send()
        if result.succeeded {
            mgClassicIntell = false
            Alertinator.shared.alert(title: "Reverted to the original Siri", body: result.message, actionLabel: "Respring", action: { mgr.shouldRespring = true })
        } else {
            Alertinator.shared.alert(title: "Failed to revert Siri!", body: result.message)
        }
    }

    // iPhone Duo mode: identity keys plus the Dynamic Island. Everything here
    // stays in memory until Apply is pressed, exactly like every other toggle.
    private func setDuoMode(_ enable: Bool) {
        if enable {
            mgProductType = Duo.productType
            mgSubtype = Duo.subtype
            store.cacheExtra[MGKey.island] = 1
            store.cacheExtra["oYicEKzVTz4/CxxE05pEgQ"] = Duo.hwModel
            store.cacheExtra["5pYKlGnYYBzGvAlIU8RjEQ"] = Duo.platform
            store.cacheExtra["97JDvERpVwO+GHtthIh7hA"] = Duo.modelNumber
        } else {
            if mgProductType == Duo.productType {
                mgProductType = ogMachineName.isEmpty ? machineName() : ogMachineName
            }
            if mgSubtype == Duo.subtype {
                mgSubtype = mgOgSubtype
            }
            store.cacheExtra.removeObject(forKey: "oYicEKzVTz4/CxxE05pEgQ")
            store.cacheExtra.removeObject(forKey: "5pYKlGnYYBzGvAlIU8RjEQ")
            store.cacheExtra.removeObject(forKey: "97JDvERpVwO+GHtthIh7hA")
            store.cacheExtra.removeObject(forKey: MGKey.island)
        }
        store.objectWillChange.send()
    }

    private func mgLoadData() -> NSMutableDictionary {
        do {
            let mgData = try Data(contentsOf: MGURL.fsGestaltURL)
            if !fm.fileExists(atPath: MGURL.savedGestaltURL.path) {
                try mgData.write(to: MGURL.savedGestaltURL)
                if let locale = Locale.current.region?.identifier {
                    showRegionTweak = locale != "US"
                }
            }
            
            if let ogDict = NSDictionary(contentsOf: MGURL.savedGestaltURL),
               let ogCacheExtra = ogDict["CacheExtra"] as? NSDictionary,
               let ogArtwork = ogCacheExtra[MGKey.artwork] as? NSDictionary {
                mgOgSubtype = ogArtwork["ArtworkDeviceSubType"] as? Int ?? 0
                mgOgDeviceName = ogArtwork["ArtworkDeviceProductDescription"] as? String ?? ""
            } else {
                throw "failed to get information from mobilegestalt"
            }
            
            // Deeply mutable parse: every nested container (CacheExtra,
            // ArtworkTraits, …) has to be writable, otherwise Apply throws
            // "failed to write keys" and no tweak ever lands.
            let currentDict = try GestaltStore.mutablePlist(from: mgData)
            
            if let cacheExtra = currentDict[MGKey.cacheExtra] as? NSDictionary,
               let artwork = cacheExtra[MGKey.artwork] as? NSDictionary {
                mgSubtype = artwork["ArtworkDeviceSubType"] as? Int ?? 0
                mgDeviceName = artwork["ArtworkDeviceProductDescription"] as? String ?? ""
                if mgDeviceName != mgOgDeviceName {
                    mgEnableDeviceName = true
                }
                mgProductType = cacheExtra[MGKey.prodType] as? String
                    ?? (ogMachineName.isEmpty ? machineName() : ogMachineName)
            }
            
            return currentDict
        } catch {
            print("(mg) failed to get mobilegestalt: \(error.localizedDescription)")
            Haptic.shared.play(.heavy)
            Alertinator.shared.alert(title: "Failed to get MobileGestalt!", body: "Tweaks will not work properly. Please leave this page.", showCancel: false, actionLabel: "Exit", action: { dismiss() })
        }
        
        return [:]
    }

    private func mgApply(isFromSheet: Bool = false) {
        do {
            let mgDictToApply = store.mgCurrentDict

            // Refuse to write anything if MobileGestalt never loaded. The old
            // code carried on regardless and could write artwork subtype 0 and
            // an empty ProductType, which breaks the device instead of
            // tweaking it.
            guard mgDictToApply[MGKey.cacheExtra] != nil else {
                throw "MobileGestalt was not loaded, so nothing was written."
            }
            let cacheExtra = store.cacheExtra

            // ArtworkTraits has to be a writable container too, otherwise the
            // subtype can never be changed and Apply just throws.
            let artwork: NSMutableDictionary
            if let existing = cacheExtra[MGKey.artwork] as? NSMutableDictionary {
                artwork = existing
            } else if let existing = cacheExtra[MGKey.artwork],
                      let data = try? PropertyListSerialization.data(fromPropertyList: existing, format: .binary, options: 0),
                      let reparsed = try? PropertyListSerialization.propertyList(from: data, options: [.mutableContainers], format: nil),
                      let promoted = reparsed as? NSMutableDictionary {
                cacheExtra[MGKey.artwork] = promoted
                artwork = promoted
            } else {
                throw "ArtworkTraits is missing or not writable in MobileGestalt."
            }

            if mgSubtype > 0 {
                artwork["ArtworkDeviceSubType"] = mgSubtype
                // An island-equipped artwork subtype (iPhone 16 Pro, 18 Pro,
                // Air, Duo, …) always switches the Dynamic Island on. The
                // subtype itself is never swapped for another device's value.
                if islandSubtypes.contains(mgSubtype) {
                    cacheExtra[MGKey.island] = 1
                }
            } else {
                print("(mg) refusing to write artwork subtype 0 - MobileGestalt did not load")
            }

            if mgEnableDeviceName && !mgDeviceName.isEmpty {
                artwork["ArtworkDeviceProductDescription"] = mgDeviceName
            }

            if mgProductType.isEmpty {
                print("(mg) refusing to write an empty ProductType")
            } else {
                cacheExtra[MGKey.prodType] = mgProductType
            }

            for item in customKeys {
                if item.isOn {
                    // Written as 1 instead of true so isEnabled() and the
                    // toggle bindings can read the value back.
                    cacheExtra[item.key] = 1
                } else {
                    cacheExtra.removeObject(forKey: item.key)
                }
            }
            
            let data = try PropertyListSerialization.data(fromPropertyList: mgDictToApply, format: .binary, options: 0)
            let res = mgWrite(data)
            
            if res {
                try? data.write(to: MGURL.appliedGestaltURL)
                print("[*] successfully overwrote mobilegestalt!")
                Haptic.shared.play(.soft)
                if autoRespring || isFromSheet {
                    mgr.shouldRespring = true
                } else {
                    Alertinator.shared.alert(title: "Successfully appiled MobileGestalt tweaks!", body: AppMsg.applied, actionLabel: "Respring", action: { mgr.shouldRespring = true })
                }
            } else {
                throw "overwrite failed!"
            }
        } catch {
            print("(mg) failed to apply mobilegestalt: \(error.localizedDescription)")
            Alertinator.shared.alert(title: "Failed to apply MobileGestalt!", body: "Error: \(error.localizedDescription)")
        }
    }
    
    private func mgRevert() {
        do {
            guard let savedData = try? Data(contentsOf: MGURL.savedGestaltURL) else {
                throw "failed to read the original mobilegestalt!"
            }
            let originalDict = try GestaltStore.mutablePlist(from: savedData)
            
            let data = try PropertyListSerialization.data(fromPropertyList: originalDict, format: .binary, options: 0)
            let res = mgWrite(data)
            
            if res {
                try? fm.removeItem(at: MGURL.appliedGestaltURL)
                print("[*] successfully overwrote mobilegestalt!")
                Haptic.shared.play(.soft)
                store.mgCurrentDict = originalDict
                // Push the reverted values into the toggles as well. Previously
                // they kept showing the tweaked values until the page was
                // re-entered, which looked like the revert had failed.
                mgSubtype = mgOgSubtype
                mgProductType = ogMachineName.isEmpty ? machineName() : ogMachineName
                mgEnableDeviceName = false
                mgDeviceName = mgOgDeviceName
                refreshStateFromStore()
                Alertinator.shared.alert(title: "Successfully reverted MobileGestalt tweaks!", body: MGMsg.revertComp)
            } else {
                throw "overwrite failed!"
            }
        } catch {
            print("(mg) failed to revert mobilegestalt: \(error.localizedDescription)")
            Alertinator.shared.alert(title: "Failed to revert MobileGestalt!", body: AppMsg.opFailed)
        }
    }
}

#Preview {
    ContentView()
}
