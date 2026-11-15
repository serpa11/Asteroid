//
//  AsteroidManager.swift
//  Asteroid
//
//  Created by lunginspector on 8/24/26.
//

import Foundation
import Combine

let build = "Release"

enum Errors {
    static var checkLogs = "Check error logs for more detailed information."
}

enum AppURL {
    static let pb = URL.documentsDirectory.appendingPathComponent("PosterBoard")
    static let pbFolders = AppURL.pb.appendingPathComponent("Wallpapers")
    static let ps = URL.documentsDirectory.appendingPathComponent("Passcode Themes")
}

enum AppMsg {
    static let opFailed = "Restart the app and try again. If this issue persists, your device may be unsupported, or this specific tweak may not work on your device properly."
    static let applied = "Respring your device for changes to take effect."
    static let unsupported = "We're sorry, but the exploits that Asteroid rely on are patched in this version. Please exit the app."
}

final class AsteroidManager: ObservableObject {
    static let shared = AsteroidManager()
    @Published var logOutput = ""
    @Published var shouldRespring = false
    @Published var refreshFiles = false

    // Set at launch when the saved tweaks could not be written back to
    // MobileGestalt; shown once as an alert so a silent failure is impossible.
    @Published var pendingRestoreWarning: String? = nil

    @Published var storedFiles = [FileItem]()
    @Published var storedURL: URL = URL(fileURLWithPath: "/")

    // True while the experimental iPhone Duo display-geometry spoof is active.
    // Respringing with it on can leave SpringBoard unable to render, so every
    // respring in the app goes through requestRespring() and warns first.
    @Published var duoGeometryActive = false

    init() {}

    /// Single entry point for respringing. When the experimental display spoof
    /// is on, four warnings are shown first - the spoof can soft-brick the
    /// device or make it unusable until Asteroid is reinstalled.
    func requestRespring() {
        Task { @MainActor [weak self] in
            guard let self else { return }

            if !self.duoGeometryActive {
                self.shouldRespring = true
                return
            }

            Alertinator.shared.warningChain(
                title: "Experimental display spoof is active",
                messages: [
                    "WARNING 1 of 4 - EXPERIMENTAL. This spoof makes MobileGestalt report a 1398x2034 display, the iPhone Duo's outer panel. iOS uses those values for real layout math, and your device does not have that screen.",
                    "WARNING 2 of 4 - Your device may SOFT-BRICK. SpringBoard can fail to render after the respring, leaving a black screen, a frozen UI, or a device that never finishes respringing.",
                    "WARNING 3 of 4 - Your device may become UNUSABLE. You could lose your home screen, lose touch input, or get stuck in a respring loop that needs a forced restart or a computer restore.",
                    "WARNING 4 of 4 - If that happens: force-restart your iPhone, reinstall Asteroid, turn this toggle OFF and press Apply to restore your real display geometry. Tap 'Respring anyway' only if you accept that risk."
                ],
                confirmLabel: "Respring anyway",
                onConfirm: { [weak self] in self?.shouldRespring = true }
            )
        }
    }
}
