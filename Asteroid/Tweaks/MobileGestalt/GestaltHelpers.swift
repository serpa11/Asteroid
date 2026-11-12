//
//  mg.swift
//  Asteroid
//
//  Created by ruter on 16.07.26.
//

import Foundation
import Darwin
import MachO
import UIKit


func mgWrite(_ data: Data) -> Bool {
    guard let propertyList = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil),
          let plist = propertyList as? NSDictionary else {
        print("(mg) failed to serialize the updated MobileGestalt: invalid property list")
        return false
    }

    do {
        let swiftPlist = plist as! [AnyHashable: Any]
        try GestaltAccess.shared().saveGestalt(swiftPlist)
        return true
    } catch {
        print("(mg) GestaltEdit backend failed to write MobileGestalt: \(error.localizedDescription)")
        return false
    }
}

// device info getters
// HD - hardware device

// iPhone 18 / iPhone Duo generation (iPhone19,*). Every current iPhone ships
// with the Dynamic Island, always-on display, charge limit, boot chime,
// crash detection, PWM dimming, camera control, action button and Apple
// Intelligence, so all of those toggles have to be hidden on them. Leaving
// them visible invites someone to switch off a key the real hardware depends
// on, which is exactly how tweaks end up "affecting the device" instead of
// helping it.
let iphone18GenHD: [String] = [
    "iPhone19,1", "iPhone19,2", "iPhone19,3", "iPhone19,4",
    "iPhone19,5", "iPhone19,6", "iPhone19,7",
]

func isDynamIslandHD() -> Bool {
    if let machineName = UserDefaults.standard.string(forKey: "ogMachineName"), iphone18GenHD.contains(machineName) {
        return true
    }
    if let machineName = UserDefaults.standard.string(forKey: "ogMachineName") {
        let hdDevices = ["iPhone15,2", "iPhone15,3", "iPhone15,4", "iPhone15,5", "iPhone16,1", "iPhone16,2", "iPhone17,3", "iPhone17,4", "iPhone17,1", "iPhone17,2", "iPhone18,3", "iPhone18,1", "iPhone18,2", "iPhone18,4"]
        if hdDevices.contains(machineName) {
            return true
        }
    }
    return false
}

func isAODHD() -> Bool {
    if let machineName = UserDefaults.standard.string(forKey: "ogMachineName"), iphone18GenHD.contains(machineName) {
        return true
    }
    if let machineName = UserDefaults.standard.string(forKey: "ogMachineName") {
        let hdDevices = ["iPhone15,2", "iPhone15,3", "iPhone16,1", "iPhone16,2", "iPhone17,1", "iPhone17,2", "iPhone18,1", "iPhone18,2", "iPhone18,3", "iPhone18,4"]
        if hdDevices.contains(machineName) {
            return true
        }
    }
    return false
}

func isChargeLimitHD() -> Bool {
    if let machineName = UserDefaults.standard.string(forKey: "ogMachineName"), iphone18GenHD.contains(machineName) {
        return true
    }
    if let machineName = UserDefaults.standard.string(forKey: "ogMachineName") {
        let hdDevices = ["iPhone15,4", "iPhone15,5", "iPhone16,1", "iPhone16,2", "iPhone17,3", "iPhone17,4", "iPhone17,1", "iPhone17,2", "iPhone17,5", "iPhone18,3", "iPhone18,1", "iPhone18,2", "iPhone18,4", "iPhone18,5", "iPad16,1", "iPad16,2", "iPad15,7", "iPad15,8", "iPad14,8", "iPad14,9", "iPad14,10", "iPad14,11", "iPad15,3", "iPad15,4", "iPad15,5", "iPad15,6", "iPad16,8", "iPad16,9", "iPad16,10", "iPad16,11", "iPad16,3", "iPad16,4", "iPad16,5", "iPad16,6", "iPad17,1", "iPad17,2", "iPad17,3", "iPad17,4"]
        if hdDevices.contains(machineName) {
            return true
        }
    }
    return false
}

func isBootChimeHD() -> Bool {
    if let machineName = UserDefaults.standard.string(forKey: "ogMachineName"), iphone18GenHD.contains(machineName) {
        return true
    }
    if let machineName = UserDefaults.standard.string(forKey: "ogMachineName") {
        let hdDevices = ["iPhone14,7", "iPhone14,8", "iPhone15,2", "iPhone15,3", "iPhone15,4", "iPhone15,5", "iPhone16,1", "iPhone16,2", "iPhone17,3", "iPhone17,4", "iPhone17,1", "iPhone17,2", "iPhone17,5", "iPhone18,1", "iPhone18,2", "iPhone18,3", "iPhone18,4", "iPhone18,5"]
        if hdDevices.contains(machineName) {
            return true
        }
    }
    return false
}

func isHomeButtonHD() -> Bool {
    // The iPhone 18 / Duo generation never has a home button, so it must not
    // be short-circuited by iphone18GenHD like the feature gates above.
    if let machineName = UserDefaults.standard.string(forKey: "ogMachineName") {
        let hdDevices: [String] = ["iPhone12,8", "iPhone14,6"]
        if hdDevices.contains(machineName) {
            return true
        }
    }
    return false
}

// fun...
func isAppleIntellHD() -> Bool {
    if let machineName = UserDefaults.standard.string(forKey: "ogMachineName"), iphone18GenHD.contains(machineName) {
        return true
    }
    if let machineName = UserDefaults.standard.string(forKey: "ogMachineName") {
        let hdDevices = ["iPhone16,1", "iPhone16,2", "iPhone17,3", "iPhone17,4", "iPhone17,1", "iPhone17,2", "iPhone17,5", "iPhone18,3", "iPhone18,1", "iPhone18,2", "iPhone18,4", "iPhone18,5", "iPad16,1", "iPad16,2", "iPad13,16", "iPad13,17", "iPad13,4", "iPad13,5", "iPad13,6", "iPad13,7", "iPad13,8", "iPad13,9", "iPad13,10", "iPad13,11", "iPad14,3", "iPad14,4", "iPad14,5", "iPad14,6", "iPad14,8", "iPad14,9", "iPad14,10", "iPad14,11", "iPad15,3", "iPad15,4", "iPad15,5", "iPad15,6", "iPad16,3", "iPad16,4", "iPad16,5", "iPad16,6", "iPad16,8", "iPad16,9", "iPad16,10", "iPad16,11", "iPad17,1", "iPad17,2", "iPad17,3", "iPad17,4"]
        if hdDevices.contains(machineName) {
            return true
        }
    }
    return false
}

func isCrashDectHD() -> Bool {
    if let machineName = UserDefaults.standard.string(forKey: "ogMachineName"), iphone18GenHD.contains(machineName) {
        return true
    }
    if let machineName = UserDefaults.standard.string(forKey: "ogMachineName") {
        let hdDevices = ["iPhone14,7", "iPhone14,8", "iPhone15,2", "iPhone15,3", "iPhone15,4", "iPhone15,5", "iPhone16,1", "iPhone16,2", "iPhone17,3", "iPhone17,4", "iPhone17,1", "iPhone17,2", "iPhone17,5", "iPhone18,3", "iPhone18,1", "iPhone18,2", "iPhone18,4", "iPhone18,5"]
        if hdDevices.contains(machineName) {
            return true
        }
    }
    return false
}

func isPWMHD() -> Bool {
    if let machineName = UserDefaults.standard.string(forKey: "ogMachineName"), iphone18GenHD.contains(machineName) {
        return true
    }
    if let machineName = UserDefaults.standard.string(forKey: "ogMachineName") {
        let hdDevices = ["iPhone18,3", "iPhone18,1", "iPhone18,2", "iPhone18,4"]
        if hdDevices.contains(machineName) {
            return true
        }
    }
    return false
}

func isCamControlHD() -> Bool {
    if let machineName = UserDefaults.standard.string(forKey: "ogMachineName"), iphone18GenHD.contains(machineName) {
        return true
    }
    if let machineName = UserDefaults.standard.string(forKey: "ogMachineName") {
        let hdDevices = ["iPhone17,3", "iPhone17,4", "iPhone17,1", "iPhone17,2", "iPhone18,3", "iPhone18,1", "iPhone18,2", "iPhone18,4"]
        if hdDevices.contains(machineName) {
            return true
        }
    }
    return false
}

func isActionButtonHD() -> Bool {
    if let machineName = UserDefaults.standard.string(forKey: "ogMachineName"), iphone18GenHD.contains(machineName) {
        return true
    }
    if let machineName = UserDefaults.standard.string(forKey: "ogMachineName") {
        let hdDevices = ["iPhone16,1", "iPhone16,2", "iPhone17,3", "iPhone17,4", "iPhone17,1", "iPhone17,2", "iPhone17,5", "iPhone18,3", "iPhone18,1", "iPhone18,2", "iPhone18,4", "iPhone18,5"]
        if hdDevices.contains(machineName) {
            return true
        }
    }
    return false
}



enum MGRestoreOutcome {
    case none               // nothing saved, or the live file already matches
    case restored           // applied tweaks were written back to MobileGestalt
    case failed(String)     // tweaks were saved but could not be written back
}

// Re-applies AppliedGestalt.plist (the exact gestalt we last wrote) whenever the
// live MobileGestalt file no longer matches it. iOS rebuilds the cache file on
// reboot/respring, which is what made every tweak disappear after a restart.
func mgRestorePersistedChanges() -> MGRestoreOutcome {
    let appliedURL = MGURL.appliedGestaltURL
    guard fm.fileExists(atPath: appliedURL.path) else { return .none }
    guard let appliedData = try? Data(contentsOf: appliedURL) else {
        return .failed("Your saved tweaks could not be read from \(appliedURL.lastPathComponent).")
    }
    // This runs from App.init(), before any screen has had the chance to ask
    // for sandbox access, so grant it here or the comparison below always
    // fails on a fresh launch and the tweaks look like they vanished.
    if !fm.isReadableFile(atPath: MGURL.fsGestaltURL.path) {
        let res = bq.grantAccess(atPath: MGURL.fsGestaltURL.deletingLastPathComponent().path,
                                 toFileName: "com.apple.MobileGestalt.plist")
        if !res.0 {
            return .failed("MobileGestalt could not be read at \(MGURL.fsGestaltURL.path). \(res.2)")
        }
    }
    guard let currentData = try? Data(contentsOf: MGURL.fsGestaltURL) else {
        return .failed("MobileGestalt could not be read at \(MGURL.fsGestaltURL.path).")
    }
    if appliedData == currentData { return .none }

    if mgWrite(appliedData) {
        return .restored
    }
    return .failed("Your saved tweaks exist, but the system refused to write them back to MobileGestalt. iOS \(vrs.majorVersion).\(vrs.minorVersion) may not allow gestalt writes.")
}

// Kept for callers that only care whether anything was written.
func mgRestorePersistedChangesIfNeeded() -> Bool {
    switch mgRestorePersistedChanges() {
    case .restored, .failed:
        return true
    case .none:
        return false
    }
}
