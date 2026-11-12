//
//  DeviceInfoHelpers.swift
//  Asteroid
//
//  Created by lunginspector on 8/14/26.
//

import Foundation

import UIKit

// rave is the internal codename for ios 27.
let vrs = ProcessInfo.processInfo.operatingSystemVersion

// Every iOS 27 build is supported: 27.0 (24A427 / 24A437 / 24A8428),
// 27.0.1 (24A446), 27.1 (24A94425), 27.2 (24B119 / 24B91020),
// 27.2.1 (24B91034), 27.3 beta 1 (24C5037i), the 27 beta 1-4 builds
// (24A5355q / 24A5370h / 24A5380h / 24A5380i / 24A5380l / 24A5390f)
// and anything Apple ships next.
func raveSupported() -> Bool {
    return vrs.majorVersion == 27
}

// iOS 27 in any build, or the supported iOS 26 range.
func isIOS27() -> Bool {
    return vrs.majorVersion == 27
}

func isSupported() -> Bool {
    if (vrs.majorVersion == 26 && vrs.minorVersion < 7) || raveSupported() {
        return true
    }
    return false
}

func doubleSysVrs() -> Double {
    let pieces = [String(vrs.majorVersion), String(vrs.minorVersion)]
    let combined = pieces.joined(separator: ".")
    return Double(combined) ?? 0.0
}



// device info getters
func machineName() -> String {
    var systemInfo = utsname()
    uname(&systemInfo)
    let machineMirror = Mirror(reflecting: systemInfo.machine)
    return machineMirror.children.reduce("") { identifier, element in
        guard let value = element.value as? Int8, value != 0 else { return identifier }
        return identifier + String(UnicodeScalar(UInt8(value)))
    }
}

func buildNumber() -> String {
    var versString = [CChar](repeating: 0, count: 16)
    var versStringLen = size_t(versString.count - 1)
    let res = sysctlbyname("kern.osversion", &versString, &versStringLen, nil, 0)
    if res == 0, let buildNum = String(validatingUTF8: versString) {
        return buildNum
    }
    return "Unknown"
}

func isPad() -> Bool {
    return UIDevice.current.userInterfaceIdiom == .pad
}
