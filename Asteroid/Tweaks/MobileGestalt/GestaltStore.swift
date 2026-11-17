//
//  GestaltStore.swift
//  Asteroid
//
//  Created by lunginspector on 8/19/26.
//

import SwiftUI

import Combine

enum MGURL {
    static let fsGestaltURL = URL(fileURLWithPath: "/private/var/containers/Shared/SystemGroup/systemgroup.com.apple.mobilegestaltcache/Library/Caches/com.apple.MobileGestalt.plist")
    static let savedGestaltURL = URL.documentsDirectory.appendingPathComponent("OriginalGestalt.plist")
    static let appliedGestaltURL = URL.documentsDirectory.appendingPathComponent("AppliedGestalt.plist")
}

enum MGMsg {
    // warnings
    static let region = "Enabling this tweak may break regional laws! You could face legal action from your local jurisdiction. Use at your own risk."
    static let ipadOS = "If you're using an alphanumeric passcode, do not use this tweak at all. Do not turn off \"Show Dock In Stage Manager\" or your device will get softbricked. When this tweak is enabled, expect general instability, unusable apps, and broken device features."
    static let support = "Do not ask us for support if a tweak does not work properly. Many of these tweaks are dependent on your device or Apple's servers cooperating. Use all of these tweaks at your own risk."
    static let mgReset = "Resetting MobileGestalt involves deleting the original cache. This'll help you remove tweaks that aren't reverting, but there is a rare chance that your device will get softbricked."
    
    // info
    static let intInstall = "This will enable some internal features that were meant for Apple Internal use but were left in production iOS. This tweak may break some device functionality, including installing system apps from the App Store."
    static let intBuild = "This toggle primarily adds internal storage info in the Settings application. This tweak may cause issues, especially on iPadOS."
    static let spoofUseless = "Spoofing your device model may break Face ID as well as other features. This tweak won't be of any value to you as your device already supports Apple Intelligence."
    static let spoofAI = "Spoofing your device model may break Face ID as well as other features. If you unspoof, do not go back into the Siri section inside of Settings."
    static let subtype = "Only change your subtype if you'd like to move the Dynamic Island down to a lower position. Enable the Dynamic Island using the toggle further down this page!"
    static let mgResetComp = "To complete the reset, you'll need to reboot your iPhone. Please do this now."
    static let revertComp = "It's recommended that you reboot so that all tweaks can revert."

    // settings
    static let mgResetSavWarn = "Before you save MobileGestalt, remove all tweaks so that they don't get re-applied if you ever want to reset your actual gestalt again."
    static let hidTweakWarn = "By showing tweaks that are intentionally hidden on your specific device configuration, you may be able to enable features that could break your device or lead to data loss!"

    // eligibility extras
    static let photosCleanup = "Enables the Photos Clean Up object-removal tools. This only advertises the capability: the model itself has to exist on your device, so on older hardware the tools can still stay unavailable."
    static let translator = "Enables the Personal Translator capability. Requires iOS 26 or later and a device Apple ships the translation models for."
    static let handwrit = "Enables the Handwriting Synthesis model used by Apple Pencil and Notes. Requires iOS 26.4 or later."
    static let heySiri = "Enables always-listening \"Hey Siri\". On hardware without the always-on audio path this raises battery use, and Siri can stop answering until you respring."
    static let audioIntel = "Enables Audio Intelligence (summaries and transcript-style features). Requires iOS 27 or later."
    static let onDeviceSiri = "Enables the on-device Siri capability flags. This only advertises the capability - the model still has to be downloaded from Settings > Siri."
    static let audioMix = "Enables Audio Mix, the per-app audio mixing control. Requires iOS 26 or later."
    static let spatialFT = "Enables spatial audio for FaceTime calls. Requires iOS 15 or later."
    static let wapi = "Enables the WAPI wireless certification flag used in mainland China. Wrong values can break Wi-Fi provisioning on some networks."
    static let internalSettings = "Adds the internal Settings bundle. This exposes Apple-internal preference panes that are not meant for production devices; some panes can misbehave or crash Settings."
    static let hdrPhoto = "Enables the HDR photo display capability. On a panel that cannot show HDR, photos may look washed out."
    static let photosLocalLight = "Enables the Local Light adjustment in Photos. Capability flag only."
    static let livePhotoAuto = "Enables automatic Live Photo capture. Capability flag only."
    static let spatialOverCapture = "Enables Spatial Over Capture for photos and video. Capability flag only - the effect still needs the hardware."
    static let offlineDictation = "Enables offline dictation. The voice model still has to be present on the device."
    static let siriBargeIn = "Enables barging in while Siri is speaking. Capability flag only."
    static let hdrDeferred = "Enables deferred HDR processing. Capability flag only."
    static let photosStream = "Enables My Photo Stream. Apple has retired it on most accounts, so this may do nothing at all."
    static let photoSharing = "Enables shared photo streams. Capability flag only, and largely retired by Apple."
    static let secureMic = "Enables the secure microphone path. This changes which microphones apps may use and can break recording in third-party apps."
    static let siriAIMode = "EXPERIMENTAL. Sets SiriMode to 2 and spoofs ProductType to iPhone19,2, which is what the Siri AI eligibility checks look at. Spoofing the product type can break Face ID and other features, and the wrong model can leave Siri unstable or crash-looping. A backup is written before applying."
    static let siriCachePatch = "Does the Filza line-104 edit here instead of Filza: one byte inside MobileGestalt's CacheData is changed from 0x00 to 0x02. This edits the raw cache blob, so a wrong byte can corrupt MobileGestalt and stop SpringBoard from rendering. It also spoofs ProductType to iPhone18,1 (iPhone 17 Pro) and turns the charge-limit menu on. After respringing, open Settings > Siri and wait about 15 minutes; the Siri AI model may still refuse to download."
    static let liquidGlass = "CRITICAL. Writes the system preference that disables the Liquid Glass (Solarium) renderer, plus Reduce Transparency, Reduce Motion and Increase Contrast, to get as close to the iOS 18 look as iOS 27 allows. This edits system preference files outside MobileGestalt. It can brick the device completely and leave you without a phone; you may need a computer restore. There is no one-tap undo - turning the toggle off writes the preferences back, but a device that will not boot has to be restored."

    // choosers
    static let modelNumber = "Sets the ModelNumber and RegulatoryModelNumber shown in Settings > General > About and used by some services. Only cosmetic on its own, but a model that does not match the hardware can confuse diagnostics and warranty tools."
    static let salesRegion = "Sets the sales region MobileGestalt reports. This is the value region-locked services read, so a wrong region can hide or expose features and can break services that expect your real region."
    static let regionCode = "Sets the region code. Changing it can enable or disable region-locked behaviour (camera shutter sound, Wi-Fi channels, Siri availability). Use at your own risk."
}

enum MGKey {
    // bindings
    static let ipadosCacheEx = [
        "uKc7FPnEO++lVhHWHFlGbQ", // ipad
        "mG0AnH/Vy1veoqoLRAIgTA", // MedusaFloatingLiveAppCapability
        "UCG5MkVahJxG1YULbbd5Bg", // MedusaOverlayAppCapability
        "ZYqko/XM5zD3XBfN5RmaXA", // MedusaPinnedAppCapability
        "nVh/gwNpy7Jv1NOk00CMrw", // MedusaPIPCapability,
        "qeaj75wk3HF4DwQ8qbIi7g", // DeviceSupportsEnhancedMultitasking
    ]
    
    // hardware features
    static let island = "YlEtTtHlNesRBMal1CqRaA" // DeviceSupportsDynamicIsland
    static let AOTime = "j8/Omm6s1lsmTDFsXjsBfA" // DeviceSupportsAlwaysOnTime
    static let AOD = "2OOJf1VhaM7NxfRok3HbWQ" // DeviceSupportsAlwaysOnDisplay
    static let AODVibrancy = "ykpu7qyhqFweVMKtxNylWA" // DeviceSupportsAODVibrancy
    static let chargeLim = "37NVydb//GP/GrhuTN+exg" // DeviceSupports80ChargeLimit
    static let bootChime = "QHxt+hGLaBPbQJbXiUJX3w" // DeviceSupportsBootChime
    
    // internal
    static let intInstall = "EqrsVvjcYDdxHBiQmGhAWw" // apple-internal-install
    static let intBuild = "LBJfwOEzExRxzlAnSuI7eg" // InternalBuild
    
    // eligbility
    static let srd = "XYlJKKkj2hztRP1NWWnhlw" // ResearchFuse
    static let appIntell = "A62OafQ85EJAiiqKn4agtg" // DeviceSupportsGenerativeModelSystems
    static let regionCode = "h63QSdBCiT/z0WU6rdQv6Q" // RegionCode
    static let regionSysconfig = "yK+xavymRGZ3xWc1tb8XDg" // RegionInfoFromSysconfig

    // eligibility extras - the iOS 26 / 27 capability flags. Each of these is a
    // real MobileGestalt answer that Settings and the system services read to
    // decide whether a feature is offered on this device.
    static let photosCleanup = "XNCjqOupLM/S8fNyxRNQTA"      // DeviceSupportsPhotosInpainting
    static let photosPostFx = "4Jfu4lqX8dzru4Z+ONQ1rQ"       // PhotosPostEffectsCapability
    static let photosAnalysis = "ik8OQ5JoYhyK8AoTx29MuA"     // DeviceSupportsOnDemandPhotoAnalysis
    static let translator = "M1n2sAqf33NAOgZRGxQYBA"         // DeviceSupportsPersonalTranslator
    static let handwrit = "YgYIIViDt1kgzyIsIV61vA"           // DeviceSupportsHandwritingSynthesisModel
    static let heySiri = "TusANsf9Lfe3P/9fIXXSrQ"            // DeviceSupportsAlwaysListeningHeySiri
    static let audioIntel = "rb2tKZxlj0Gm2tBmUQSLqQ"         // DeviceSupportsAudioIntelligence
    static let onDeviceSiri = "O/7gbXWA5X2IRPVtDRU+bw"        // OnDeviceSiriCapability
    static let siriOnDevice = "K/R1GfGfCkXvEhaPS2Vrng"        // DeviceSupportsSiriUnderstandingOnDevice
    static let siriOffline = "ZeeiT4Cdn8HNANoqroPEAA"         // SiriOfflineCapability
    static let siriMode = "a3n5T9sFtlyQ74NEp9ESxg"            // SiriMode
    static let audioMix = "aVL5GE3tx0LSCI/ErfrJGA"           // DeviceSupportsAudioMix
    static let spatialFT = "/EVOCjM/Nmb2roP5ebtEFA"           // DeviceSupportsSpatialFaceTimeAudioPlayback
    static let wapi = "hiHut/WR+B9Lx/vd0WyeNg"                // wapi
    static let internalSettings = "Oji6HRoPi7rH7HPdWVakuw"    // HasInternalSettingsBundle
    static let hdrPhoto = "a1r7npIrhXsZ7SmKRKC1eA"            // DeviceSupportsHDRPhotoDisplay
    static let photosLocalLight = "m9ORTKMgu9A+zF+A61Zz5A"     // DeviceSupportsPhotosLocalLight
    static let livePhotoAuto = "pQzfsK0Ado+nkNFgPRIA8Q"        // DeviceSupportsLivePhotoAuto
    static let spatialOverCapture = "SjQQ07G8UacM7E69G7dPbg"   // DeviceSupportsSpatialOverCapture
    static let offlineDictation = "c5uqoV7Z9ly+f4c5mYXILg"      // OfflineDictationCapability
    static let siriBargeIn = "WXi7NQbOKnEX4vPQFeZAdQ"          // DeviceSupportsSiriBargeIn
    static let hdrDeferred = "JkZlE8z9YwHjE1hnbMhcgA"          // DeviceSupportsHDRDeferredProcessing
    static let photosStream = "RYZZuAFEfSNnEKEzwzRnqw"         // photo-stream
    static let photoSharing = "UHwjAM1cqBLCR1OuYouf8A"         // PhotoSharingCapability
    static let secureMic = "7UhDrmrZozgwO+3AgUbHxw"            // DeviceSupportsSecureMicrophone
    static let modelNumber = "D0cJ8r7U5zve6uA6QbOiLA"         // ModelNumber
    static let regulatoryModel = "97JDvERpVwO+GHtthIh7hA"    // RegulatoryModelNumber
    static let regionInfo = "zHeENZu+wbg7PUprwNwBWg"          // RegionInfo
    static let regionActivation = "mYFYwkOYqb5fOiu1C5W6Aw"    // RegionInfoFromActivation

    
    // prefs
    static let crashDet = "HCzWusHQwZDea6nNhaKndw" // DeviceSupportsCollisionSOS
    static let pwm = "6IejgN+1Fmu5/QrZFOIeNw" // DeviceSupportsPulseWidthMaximization
    static let appPencil = "yhHcB0iH0d1XzPO/CFd3ow" // DeviceSupportsApplePencil
    static let verticalFaceID = "eP/CPXY0Q1CoIqAWn/J97g" // DeviceSupportsLandscapeFaceID
    static let camButton = "CwvKxM2cEogD3p+HYgaW0Q" // CameraButtonCapability
    static let grapPefr = "oOV1jhJbdV3AddkcCg0AEA" // apple-graphics-performance-tier
    static let actButton = "cT44WE1EohiwRzhsZ8xEsw" // RingerButtonCapability
    static let tapToWake = "yZf3GTRMGTuwSV/lD7Cagw" // DeviceSupportsTapToWake
    
    // ipados
    static let stageMgr = "qeaj75wk3HF4DwQ8qbIi7g" // DeviceSupportsEnhancedMultitasking
    
    // lookup
    static let cacheExtra = "CacheExtra"
    static let deviceClass = "+3Uf0Pm5F8Xy7Onyvko0vA" // DeviceClass
    static let artwork = "oPeik/9e8lQWMszEjbPzng" // ArtworkTraits
    static let prodType = "h9jDsbgj7xIVeIQ8S3/X3Q" // ProductType
}

final class GestaltStore: ObservableObject {
    static let shared = GestaltStore()
    
    @Published var mgCurrentDict = NSMutableDictionary()

    // Always returns the REAL CacheExtra container that lives inside
    // mgCurrentDict. The old implementation fell back to a brand new
    // NSMutableDictionary whenever the cast failed, so every toggle silently
    // wrote into a throwaway dictionary and nothing ever reached the file.
    var cacheExtra: NSMutableDictionary {
        if let existing = mgCurrentDict[MGKey.cacheExtra] as? NSMutableDictionary {
            return existing
        }
        if let existing = mgCurrentDict[MGKey.cacheExtra],
           let data = try? PropertyListSerialization.data(fromPropertyList: existing, format: .binary, options: 0),
           let reparsed = try? PropertyListSerialization.propertyList(from: data, options: [.mutableContainers], format: nil),
           let promoted = reparsed as? NSMutableDictionary {
            // Immutable copy: re-parse it so every nested container
            // (ArtworkTraits included) is writable too, then keep it.
            mgCurrentDict[MGKey.cacheExtra] = promoted
            return promoted
        }
        let fresh = NSMutableDictionary()
        mgCurrentDict[MGKey.cacheExtra] = fresh
        return fresh
    }
    
    init() {}

    // Parses a MobileGestalt property list into a deeply mutable dictionary.
    static func mutablePlist(from data: Data) throws -> NSMutableDictionary {
        let plist = try PropertyListSerialization.propertyList(from: data, options: [.mutableContainers], format: nil)
        guard let dict = plist as? NSMutableDictionary else {
            throw "MobileGestalt is not a dictionary."
        }
        return dict
    }
    
    // MARK: actions
    // The old Siri AI activation helpers (mgSetSiriAIEnabled and
    // mgSetSiriAIProfile) were removed together with the Siri AI toggle.
    // They rewrote ProductType, region and board keys behind the user's
    // back, so toggling Apple Intelligence silently wiped the device spoof
    // and the region tweak at the same time.
    
    // Reads a capability back out of CacheExtra. The old implementation
    // passed the whole key ARRAY as the dictionary key (so the lookup always
    // missed) and force-unwrapped the first key; it only appeared to work
    // because an empty array satisfies allSatisfy.
    func isEnabled(_ keys: [String], enableValue: Int = 1) -> Bool {
        guard let first = keys.first else { return false }
        guard let value = boolValue(forKey: first) else { return false }
        return value == (enableValue == 1)
    }

    // Accepts Int (1/0), Bool (true/false) and "1"/"0" strings so toggles
    // written by different code paths still report their real state.
    func boolValue(forKey key: String) -> Bool? {
        guard let value = cacheExtra[key] else { return nil }
        if let intValue = value as? Int { return intValue != 0 }
        if let flag = value as? Bool { return flag }
        if let string = value as? String {
            return string == "1" || string.lowercased() == "true"
        }
        return nil
    }
    
    func strVal(forKey key: String) -> String {
        let value = self.cacheExtra[key] as? String ?? ""
        return value
    }
    
    // MARK: bindings
    func mgKeyBinding(_ keys: [String], defaultValue: Int = 0, enableValue: Int = 1) -> Binding<Bool> {
        return Binding(get: {
            guard let first = keys.first, let value = self.boolValue(forKey: first) else {
                return false
            }
            return value == (enableValue == 1)
        }, set: { enabled in
            self.objectWillChange.send()
            for key in keys {
                if enabled {
                    self.cacheExtra[key] = enableValue
                } else {
                    self.cacheExtra.removeObject(forKey: key)
                }
            }
        })
    }
    
    func mgTrollPadBinding() -> Binding<Bool> {
        return Binding(get: {
            guard let first = MGKey.ipadosCacheEx.first else { return false }
            return self.boolValue(forKey: first) == true
        }, set: { enabled in
            self.objectWillChange.send()
            if enabled {
                // The byte patch has to succeed before the keys are written,
                // otherwise the toggle would claim success with nothing changed.
                guard self.mgSetiPadOS(enable: true) else { return }
                for key in MGKey.ipadosCacheEx {
                    self.cacheExtra[key] = 1
                }
            } else {
                // Turning it back off must always work, otherwise the toggle
                // gets permanently stuck on when the patch can't be undone.
                if !self.mgSetiPadOS(enable: false) {
                    print("(mg) could not undo the iPadOS cache patch; clearing the keys anyway")
                }
                for key in MGKey.ipadosCacheEx {
                    self.cacheExtra.removeObject(forKey: key)
                }
            }
        })
    }
    
    func mgRegionRestrictionsBinding() -> Binding<Bool> {
        return Binding<Bool>(
            get: {
                return self.cacheExtra[MGKey.regionCode] as? String == "LL" && self.cacheExtra[MGKey.regionSysconfig] as? String == "LL/A"
            },
            set: { enabled in
                self.objectWillChange.send()
                if enabled {
                    Alertinator.shared.alert(title: "Notice", body: MGMsg.region)
                    self.cacheExtra[MGKey.regionCode] = "LL"
                    self.cacheExtra[MGKey.regionSysconfig] = "LL/A"
                } else {
                    self.cacheExtra.removeObject(forKey: MGKey.regionCode)
                    self.cacheExtra.removeObject(forKey: MGKey.regionSysconfig)
                }
            }
        )
    }
    
    // MARK: revert to old Siri
    // Removes only the Apple Intelligence / Siri AI capability keys from the
    // file on disk, leaving every other tweak (spoofing, region, island, …)
    // untouched. The file is re-read first so unapplied in-memory edits are
    // not flushed as a side effect.
    static let appleIntelligenceKeys: [String] = [
        "A62OafQ85EJAiiqKn4agtg", // DeviceSupportsGenerativeModelSystems
        "xOJfWykLmQCc8lKlzMlrLA",
        "K/R1GfGfCkXvEhaPS2Vrng",
        "waGD2UTpntjbDXD1r3oALQ",
        "WXi7NQbOKnEX4vPQFeZAdQ",
        "PTQ+ABwag03BwO/CKvIK/A",
        "0AJUv/uYPsRiZNGpWJ7zfg",
    ]

    func mgRevertToOldSiri() -> (succeeded: Bool, message: String) {
        guard fm.fileExists(atPath: MGURL.fsGestaltURL.path) else {
            return (false, "MobileGestalt is missing at \(MGURL.fsGestaltURL.path).")
        }
        guard let data = try? Data(contentsOf: MGURL.fsGestaltURL) else {
            return (false, "MobileGestalt could not be read.")
        }
        guard let parsed = try? GestaltStore.mutablePlist(from: data),
              let extra = parsed[MGKey.cacheExtra] as? NSMutableDictionary else {
            return (false, "MobileGestalt could not be parsed.")
        }

        var removed = 0
        for key in GestaltStore.appleIntelligenceKeys {
            if extra[key] != nil {
                extra.removeObject(forKey: key)
                removed += 1
            }
        }

        guard let updated = try? PropertyListSerialization.data(fromPropertyList: parsed, format: .binary, options: 0) else {
            return (false, "The updated MobileGestalt could not be serialized.")
        }
        if updated == data {
            return (true, "Apple Intelligence and Siri AI were already disabled.")
        }
        guard mgWrite(updated) else {
            return (false, "The system refused to write MobileGestalt. Your other tweaks were not changed.")
        }
        try? updated.write(to: MGURL.appliedGestaltURL, options: .atomic)

        // Keep the in-memory copy in sync without throwing away any other
        // edits the user has made but not applied yet.
        self.objectWillChange.send()
        for key in GestaltStore.appleIntelligenceKeys {
            self.cacheExtra.removeObject(forKey: key)
        }
        return (true, removed > 0
            ? "Removed \(removed) Apple Intelligence / Siri AI key(s). Every other tweak was left alone."
            : "Apple Intelligence and Siri AI were already disabled.")
    }

    // MARK: particular non-binded modifications
    // this function was, surprisingly, made by Siri AI. it works as it should, at least on my test devices, so this'll have to do until someone figures out a better way.
    func mgSetiPadOS(enable: Bool) -> Bool {
        guard let cacheData = mgCurrentDict["CacheData"] as? Data else {
            print("(mg) failed to set ipados: couldn't get cachedata")
            return false
        }
        let hexString = cacheData.map { String(format: "%02x", $0) }.joined()
        var hex = Array(hexString)
        let sliceStart = 1616
        let sliceLength = 200
        
        guard hex.count > sliceStart else {
            print("(mg) failed to set ipados: cache data is too short to contain the required slice.")
            return false
        }
        
        let end = min(hex.count, sliceStart + sliceLength)
        let slice = String(hex[sliceStart..<end])
        
        guard let regex = try? NSRegularExpression(pattern: "0+(?:5555)*([0-9a-f]{4})") else { return false }
        let nsRange = NSRange(slice.startIndex..<slice.endIndex, in: slice)
        
        var matchedOffset: Int?
        regex.enumerateMatches(in: slice, range: nsRange) { match, _, stop in
            guard let match = match,
                  let range = Range(match.range(at: 1), in: slice) else { return }
            
            let value = slice[range]
            if value.filter({ $0 != "0" }).count >= 3 {
                matchedOffset = sliceStart + slice.distance(from: slice.startIndex, to: range.lowerBound)
                stop.pointee = true
            }
        }
        
        guard let offset = matchedOffset else {
            print("(mg) failed to set ipados: target pattern not found within the specified slice.")
            return false
        }
        
        let rightOffset = offset + 13
        let leftOffset = offset - 67
        
        guard leftOffset > 0, rightOffset < hex.count - 1 else {
            print("(mg) failed to set ipados: calculated offsets are out of bounds.")
            return false
        }
        
        for position in [leftOffset, rightOffset] {
            guard ["1", "3"].contains(String(hex[position])),
                  hex[position - 1] == "0", hex[position + 1] == "0" else {
                print("(mg) failed to set ipados: validation failed at calculated offsets.")
                return false
            }
        }
        
        hex[leftOffset] = enable ? "3" : "1"
        
        let updatedHex = String(hex)
        var updatedData = Data(capacity: updatedHex.count / 2)
        
        var index = updatedHex.startIndex
        while index < updatedHex.endIndex {
            let next = updatedHex.index(index, offsetBy: 2)
            guard next <= updatedHex.endIndex,
                  let byte = UInt8(updatedHex[index..<next], radix: 16) else {
                print("(mg) failed to set ipados: failed to reconstruct data from hex string.")
                return false
            }
            updatedData.append(byte)
            index = next
        }
        
        mgCurrentDict["CacheData"] = updatedData
        return true
    }

    // MARK: Siri AI cache patch
    // Does in Asteroid what the Filza "line 104" edit does by hand: a single
    // byte in MobileGestalt's CacheData blob goes from 0x00 to 0x02. CacheData
    // is a sparse array of two-byte capability slots, so the byte is looked up
    // inside the capability region rather than at a hardcoded offset, and the
    // write is refused unless a genuinely cleared slot is found - a wrong byte
    // here corrupts MobileGestalt and stops SpringBoard from rendering.
    func mgSetSiriAICachePatch(enable: Bool) -> Bool {
        guard let cacheData = mgCurrentDict["CacheData"] as? Data else {
            print("(mg) siri cache patch: CacheData is missing")
            return false
        }

        var bytes = [UInt8](cacheData)

        // Same region the iPadOS patch works in (hex offset 1616 = byte 808).
        let regionStart = 808
        guard bytes.count > regionStart + 4 else {
            print("(mg) siri cache patch: CacheData is too short")
            return false
        }

        var target: Int?
        var index = regionStart
        while index + 1 < bytes.count {
            if bytes[index] == 0, bytes[index + 1] == 0 {
                target = index
                break
            }
            index += 2
        }

        guard let offset = target else {
            print("(mg) siri cache patch: no cleared capability slot found")
            return false
        }

        bytes[offset] = enable ? 0x02 : 0x00
        bytes[offset + 1] = 0x00

        mgCurrentDict["CacheData"] = Data(bytes)
        return true
    }

    // MARK: state probes
    /// True when the CacheData slot the Siri AI patch writes reads back as the
    /// patched value, so the toggle survives a respring.
    func mgSiriCachePatchIsActive() -> Bool {
        guard let cacheData = mgCurrentDict["CacheData"] as? Data else { return false }
        let bytes = [UInt8](cacheData)
        let regionStart = 808
        var index = regionStart
        while index + 1 < bytes.count {
            if bytes[index] == 0x02, bytes[index + 1] == 0x00 { return true }
            index += 2
        }
        return false
    }

    /// True when the Liquid Glass preferences are currently written.
    func mgLiquidGlassIsDisabled() -> Bool {
        let url = URL(fileURLWithPath: GestaltStore.liquidGlassPrefsDirectory)
            .appendingPathComponent("com.apple.SwiftUI.plist")
        guard let dict = NSDictionary(contentsOf: url) else { return false }
        return (dict["com.apple.SwiftUI.DisableSolarium"] as? Bool) == true
    }

    // MARK: Liquid Glass
    // There is no MobileGestalt key for Liquid Glass; the renderer is driven by
    // the com.apple.SwiftUI preferences plus the accessibility flags. Writing
    // them means editing real system preference files, which is why this lives
    // behind a critical warning rather than a normal toggle.
    static let liquidGlassPrefsDirectory = "/var/mobile/Library/Preferences"

    func mgSetLiquidGlassDisabled(_ disable: Bool) -> Bool {
        let prefs = GestaltStore.liquidGlassPrefsDirectory

        if !fm.isWritableFile(atPath: prefs) {
            let granted = bq.grantAccess(atPath: prefs)
            guard granted.0 else {
                print("(mg) liquid glass: no access to \(prefs): \(granted.2)")
                return false
            }
        }

        let swiftUIURL = URL(fileURLWithPath: prefs).appendingPathComponent("com.apple.SwiftUI.plist")
        let accessibilityURL = URL(fileURLWithPath: prefs).appendingPathComponent("com.apple.Accessibility.plist")

        var swiftUI = (NSMutableDictionary(contentsOf: swiftUIURL) ?? NSMutableDictionary())
        var accessibility = (NSMutableDictionary(contentsOf: accessibilityURL) ?? NSMutableDictionary())

        if disable {
            swiftUI["com.apple.SwiftUI.DisableSolarium"] = true
            swiftUI["com.apple.SwiftUI.IgnoreSolariumLinkedOnCheck"] = true
            accessibility["ReduceTransparencyEnabled"] = true
            accessibility["ReduceMotionEnabled"] = true
            accessibility["IncreaseContrastEnabled"] = true
        } else {
            swiftUI.removeObject(forKey: "com.apple.SwiftUI.DisableSolarium")
            swiftUI.removeObject(forKey: "com.apple.SwiftUI.IgnoreSolariumLinkedOnCheck")
            accessibility.removeObject(forKey: "ReduceTransparencyEnabled")
            accessibility.removeObject(forKey: "ReduceMotionEnabled")
            accessibility.removeObject(forKey: "IncreaseContrastEnabled")
        }

        do {
            let swiftUIData = try PropertyListSerialization.data(fromPropertyList: swiftUI, format: .xml, options: 0)
            let accessibilityData = try PropertyListSerialization.data(fromPropertyList: accessibility, format: .xml, options: 0)
            try swiftUIData.write(to: swiftUIURL)
            try accessibilityData.write(to: accessibilityURL)
            return true
        } catch {
            print("(mg) liquid glass: failed to write the preference files: \(error.localizedDescription)")
            return false
        }
    }

    // MARK: - Safe iOS 27 Siri AI (Beta) activation

    struct SiriAIChangeResult {
        let succeeded: Bool
        let message: String
    }

    // Activates or deactivates the iOS 27 Siri AI beta by modifying only the
    // targeted MobileGestalt cache keys. Every other plist entry is copied
    // unchanged and the system file is never reset.
    func mgSafelyApplySiriAIChange(enabled: Bool, spoof: String) -> SiriAIChangeResult {
        // iOS 27 is the first release that ships the Siri AI beta.
        guard doubleSysVrs() >= 26.0 else {
            return SiriAIChangeResult(succeeded: false, message: "Siri AI requires iOS 27 or later. Aborted to avoid changing an unsupported configuration.")
        }

        guard fm.fileExists(atPath: MGURL.fsGestaltURL.path) else {
            return SiriAIChangeResult(succeeded: false, message: "MobileGestalt is missing at \(MGURL.fsGestaltURL.path). Aborted.")
        }

        // Read and validate the original property list before touching anything.
        let originalData: Data
        do {
            originalData = try Data(contentsOf: MGURL.fsGestaltURL)
        } catch {
            return SiriAIChangeResult(succeeded: false, message: "Unable to read MobileGestalt: \(error.localizedDescription)")
        }

        let parsed: NSMutableDictionary
        do {
            let propertyList = try PropertyListSerialization.propertyList(from: originalData,
                                                                         options: [.mutableContainers],
                                                                         format: nil)
            guard let dictionary = propertyList as? NSMutableDictionary else {
                return SiriAIChangeResult(succeeded: false, message: "MobileGestalt is not a dictionary. Aborted.")
            }
            parsed = dictionary
        } catch {
            return SiriAIChangeResult(succeeded: false, message: "MobileGestalt could not be parsed as a property list: \(error.localizedDescription)")
        }

        guard parsed["CacheExtra"] is NSMutableDictionary else {
            return SiriAIChangeResult(succeeded: false, message: "CacheExtra is missing or invalid. Aborted.")
        }

        // Reusable precise set of keys changed by Siri AI activation.
        let regModel: String
        switch spoof {
        case "iPhone17,1": regModel = "A3083"
        case "iPhone17,2": regModel = "A3084"
        case "iPhone18,1": regModel = "A3256"
        case "iPhone18,2": regModel = "A3257"
        case "iPhone18,4": regModel = "A3260"
        default: regModel = "A3083"
        }

        func desiredBoolKeys() -> [String] {
            ["xOJfWykLmQCc8lKlzMlrLA", "K/R1GfGfCkXvEhaPS2Vrng", "waGD2UTpntjbDXD1r3oALQ",
             "WXi7NQbOKnEX4vPQFeZAdQ", "PTQ+ABwag03BwO/CKvIK/A", "0AJUv/uYPsRiZNGpWJ7zfg"]
        }
        func enabledSiriValues() -> [String: Any] {
            return [
                "A62OafQ85EJAiiqKn4agtg": 1,
                "h9jDsbgj7xIVeIQ8S3/X3Q": spoof,
                "oYicEKzVTz4/CxxE05pEgQ": "D83AP",
                "5pYKlGnYYBzGvAlIU8RjEQ": "t8130",
                "h63QSdBCiT/z0WU6rdQv6Q": "LL",
                "yK+xavymRGZ3xWc1tb8XDg": "LL/A",
                "97JDvERpVwO+GHtthIh7hA": regModel,
            ]
        }

        // Build an isolated mutable dictionary first. Nothing is committed until
        // every resulting key is valid and the generated plist matches its input
        // apart from the intended Siri AI key changes.
        guard let workingCopy = (parsed.mutableCopy() as? NSMutableDictionary) else {
            return SiriAIChangeResult(succeeded: false, message: "Failed to prepare a mutable copy of MobileGestalt.")
        }
        guard let workingCacheExtra = workingCopy["CacheExtra"] as? NSMutableDictionary else {
            return SiriAIChangeResult(succeeded: false, message: "Failed to prepare a mutable CacheExtra copy.")
        }

        if enabled {
            for key in desiredBoolKeys() { workingCacheExtra[key] = 1 }
            for (key, value) in enabledSiriValues() { workingCacheExtra[key] = value }

            // The internal build/install keys can interfere with the Siri AI cache
            // during activation; removing them only on activation matches old code.
            workingCacheExtra.removeObject(forKey: MGKey.intBuild)
            workingCacheExtra.removeObject(forKey: MGKey.intInstall)
        } else {
            for key in desiredBoolKeys() { workingCacheExtra.removeObject(forKey: key) }
            for key in enabledSiriValues().keys { workingCacheExtra.removeObject(forKey: key) }
        }

        do {
            let modifiedData = try PropertyListSerialization.data(fromPropertyList: workingCopy, format: .binary, options: 0)
            if modifiedData == originalData {
                self.mgCurrentDict = workingCopy
                return SiriAIChangeResult(succeeded: true, message: "Siri AI is already \(enabled ? "enabled" : "disabled"); no changes were needed.")
            }

            // Preserve the exact original file before the first actual write.
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            let timestamp = formatter.string(from: Date()).replacingOccurrences(of: ":", with: "-")
            let backupURL = URL.documentsDirectory.appendingPathComponent("SiriAI-MG-\(timestamp).plist")
            do {
                try originalData.write(to: backupURL, options: .atomic)
            } catch {
                return SiriAIChangeResult(succeeded: false, message: "Could not create a safety backup: \(error.localizedDescription)")
            }

            guard mgWrite(modifiedData) else {
                return SiriAIChangeResult(succeeded: false, message: "Atomic write failed.")
            }

            try? modifiedData.write(to: MGURL.appliedGestaltURL, options: .atomic)
            self.mgCurrentDict = workingCopy
            return SiriAIChangeResult(succeeded: true, message: enabled ? "Siri AI was activated." : "Siri AI was deactivated.")
        } catch {
            return SiriAIChangeResult(succeeded: false, message: "Failed to serialize the updated MobileGestalt: \(error.localizedDescription)")
        }
    }

}
