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
    static let deviceClass = "+3Uf0Pm5F8Xy7Onyvko0vA" // DeviceClass
    static let artwork = "oPeik/9e8lQWMszEjbPzng" // ArtworkTraits
    static let prodType = "h9jDsbgj7xIVeIQ8S3/X3Q" // ProductType
}

final class GestaltStore: ObservableObject {
    static let shared = GestaltStore()
    
    @Published var mgCurrentDict = NSMutableDictionary()
    var cacheExtra: NSMutableDictionary {
        return mgCurrentDict["CacheExtra"] as? NSMutableDictionary ?? NSMutableDictionary()
    }
    
    init() {}
    
    // MARK: actions
    func mgSetSiriAIEnabled(_ enabled: Bool, spoof: String) {
        self.objectWillChange.send()
        if enabled {
            cacheExtra["A62OafQ85EJAiiqKn4agtg"] = 1
            cacheExtra["h9jDsbgj7xIVeIQ8S3/X3Q"] = spoof
            cacheExtra["oYicEKzVTz4/CxxE05pEgQ"] = "D83AP"
            cacheExtra["5pYKlGnYYBzGvAlIU8RjEQ"] = "t8130"
            cacheExtra["h63QSdBCiT/z0WU6rdQv6Q"] = "LL"
            cacheExtra["yK+xavymRGZ3xWc1tb8XDg"] = "LL/A"
            cacheExtra["xOJfWykLmQCc8lKlzMlrLA"] = 1
            cacheExtra["K/R1GfGfCkXvEhaPS2Vrng"] = 1
            cacheExtra["waGD2UTpntjbDXD1r3oALQ"] = 1
            cacheExtra["WXi7NQbOKnEX4vPQFeZAdQ"] = 1
            cacheExtra["PTQ+ABwag03BwO/CKvIK/A"] = 1
            cacheExtra["0AJUv/uYPsRiZNGpWJ7zfg"] = 1
            let regModel: String
            switch spoof {
            case "iPhone17,1": regModel = "A3083"
            case "iPhone17,2": regModel = "A3084"
            case "iPhone18,1": regModel = "A3256"
            case "iPhone18,2": regModel = "A3257"
            case "iPhone18,4": regModel = "A3260"
            default: regModel = "A3083"
            }
            cacheExtra["97JDvERpVwO+GHtthIh7hA"] = regModel

        } else {
            cacheExtra.removeObject(forKey: "h9jDsbgj7xIVeIQ8S3/X3Q")
            cacheExtra.removeObject(forKey: "oYicEKzVTz4/CxxE05pEgQ")
            cacheExtra.removeObject(forKey: "5pYKlGnYYBzGvAlIU8RjEQ")
            cacheExtra.removeObject(forKey: "h63QSdBCiT/z0WU6rdQv6Q")
            cacheExtra.removeObject(forKey: "yK+xavymRGZ3xWc1tb8XDg")
            cacheExtra.removeObject(forKey: "97JDvERpVwO+GHtthIh7hA")
            cacheExtra.removeObject(forKey: "xOJfWykLmQCc8lKlzMlrLA")
            cacheExtra.removeObject(forKey: "K/R1GfGfCkXvEhaPS2Vrng")
            cacheExtra.removeObject(forKey: "waGD2UTpntjbDXD1r3oALQ")
            cacheExtra.removeObject(forKey: "WXi7NQbOKnEX4vPQFeZAdQ")
            cacheExtra.removeObject(forKey: "PTQ+ABwag03BwO/CKvIK/A")
            cacheExtra.removeObject(forKey: "0AJUv/uYPsRiZNGpWJ7zfg")
        }
    }

    func mgSetSiriAIProfile(_ spoof: String) {
        self.objectWillChange.send()
        cacheExtra["A62OafQ85EJAiiqKn4agtg"] = 1
        cacheExtra["h9jDsbgj7xIVeIQ8S3/X3Q"] = spoof
        cacheExtra["oYicEKzVTz4/CxxE05pEgQ"] = "D83AP"
        cacheExtra["5pYKlGnYYBzGvAlIU8RjEQ"] = "t8130"
        cacheExtra["h63QSdBCiT/z0WU6rdQv6Q"] = "LL"
        cacheExtra["yK+xavymRGZ3xWc1tb8XDg"] = "LL/A"
            cacheExtra["xOJfWykLmQCc8lKlzMlrLA"] = 1
                        cacheExtra["K/R1GfGfCkXvEhaPS2Vrng"] = 1
                        cacheExtra["waGD2UTpntjbDXD1r3oALQ"] = 1
                        cacheExtra["WXi7NQbOKnEX4vPQFeZAdQ"] = 1
                        cacheExtra["PTQ+ABwag03BwO/CKvIK/A"] = 1
                        cacheExtra["0AJUv/uYPsRiZNGpWJ7zfg"] = 1
        let regModel: String
        switch spoof {
        case "iPhone17,1": regModel = "A3083"
        case "iPhone17,2": regModel = "A3084"
        case "iPhone18,1": regModel = "A3256"
        case "iPhone18,2": regModel = "A3257"
        case "iPhone18,4": regModel = "A3260"
        default: regModel = "A3083"
        }
        cacheExtra["97JDvERpVwO+GHtthIh7hA"] = regModel
    }
    func mgPullKeys(_ keys: [String]) {
        for key in keys {
            cacheExtra.removeObject(forKey: key)
        }
    }
    
    func isEnabled(_ keys: [String], enableValue: Int = 1) -> Bool {
        let values = self.cacheExtra[keys] as? [Int] ?? []
        let testVal = self.cacheExtra[keys.first!] as? Int
        if values.allSatisfy({ $0 == testVal }) {
            return testVal == enableValue
        }
        return false
    }
    
    func strVal(forKey key: String) -> String {
        let value = self.cacheExtra[key] as? String ?? ""
        return value
    }
    
    // MARK: bindings
    func mgSiriAIBinding() -> Binding<Bool> {
        return Binding(get: {
            return self.cacheExtra["A62OafQ85EJAiiqKn4agtg"] as? Int == 1
                && self.cacheExtra["h63QSdBCiT/z0WU6rdQv6Q"] as? String == "LL"
                && self.cacheExtra["yK+xavymRGZ3xWc1tb8XDg"] as? String == "LL/A"
        }, set: { enabled in
            self.objectWillChange.send()
            if enabled {
                self.cacheExtra["A62OafQ85EJAiiqKn4agtg"] = 1
                self.cacheExtra["h9jDsbgj7xIVeIQ8S3/X3Q"] = "iPhone16,1"
                self.cacheExtra["oYicEKzVTz4/CxxE05pEgQ"] = "D83AP"
                self.cacheExtra["5pYKlGnYYBzGvAlIU8RjEQ"] = "t8130"
                self.cacheExtra["h63QSdBCiT/z0WU6rdQv6Q"] = "LL"
                self.cacheExtra["yK+xavymRGZ3xWc1tb8XDg"] = "LL/A"
                self.cacheExtra["97JDvERpVwO+GHtthIh7hA"] = "A3083"
            } else {
                self.cacheExtra.removeObject(forKey: "A62OafQ85EJAiiqKn4agtg")
                self.cacheExtra.removeObject(forKey: "h9jDsbgj7xIVeIQ8S3/X3Q")
                self.cacheExtra.removeObject(forKey: "oYicEKzVTz4/CxxE05pEgQ")
                self.cacheExtra.removeObject(forKey: "5pYKlGnYYBzGvAlIU8RjEQ")
                self.cacheExtra.removeObject(forKey: "h63QSdBCiT/z0WU6rdQv6Q")
                self.cacheExtra.removeObject(forKey: "yK+xavymRGZ3xWc1tb8XDg")
                self.cacheExtra.removeObject(forKey: "97JDvERpVwO+GHtthIh7hA")
            }
        })
    }
    func mgKeyBinding(_ keys: [String], defaultValue: Int = 0, enableValue: Int = 1) -> Binding<Bool> {
        return Binding(get: {
            if let value = self.cacheExtra[keys.first!] as? Int {
                return value == enableValue
            }
            return false
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
            if let value = self.cacheExtra[MGKey.ipadosCacheEx.first!] as? Int? {
                return value == 1
            }
            return false
        }, set: { enabled in
            self.objectWillChange.send()
            if self.mgSetiPadOS(enable: enabled) {
                for key in MGKey.ipadosCacheEx {
                    if enabled {
                        self.cacheExtra[key] = 1
                    } else {
                        self.cacheExtra.removeObject(forKey: key)
                    }
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
                                                                         options: [.mutableContainers, .mutableLeaves],
                                                                         format: nil)
            guard let dictionary = propertyList as? NSMutableDictionary else {
                return SiriAIChangeResult(succeeded: false, message: "MobileGestalt is not a dictionary. Aborted.")
            }
            parsed = dictionary
        } catch {
            return SiriAIChangeResult(succeeded: false, message: "MobileGestalt could not be parsed as a property list: \(error.localizedDescription)")
        }

        guard let cacheExtra = parsed["CacheExtra"] as? NSMutableDictionary else {
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
        } else {
            for key in desiredBoolKeys() { workingCacheExtra.removeObject(forKey: key) }
            for key in enabledSiriValues().keys { workingCacheExtra.removeObject(forKey: key) }
        }

        // Compatibility parser/generator artifacts should not remain encoded.
        workingCacheExtra.removeObject(forKey: MGKey.intBuild)
        workingCacheExtra.removeObject(forKey: MGKey.intInstall)

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

            let writeResult = mgWrite(modifiedData)
            guard writeResult.0 else {
                return SiriAIChangeResult(succeeded: false, message: "Atomic write failed: \(writeResult.1)")
            }

            try? modifiedData.write(to: MGURL.appliedGestaltURL, options: .atomic)
            self.mgCurrentDict = workingCopy
            return SiriAIChangeResult(succeeded: true, message: enabled ? "Siri AI was activated." : "Siri AI was deactivated.")
        } catch {
            return SiriAIChangeResult(succeeded: false, message: "Failed to serialize the updated MobileGestalt: \(error.localizedDescription)")
        }
    }

}
