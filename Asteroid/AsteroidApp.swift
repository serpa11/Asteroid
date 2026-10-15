//
//  AsteroidApp.swift
//  Asteroid
//
//  Created by lunginspector on 8/14/26.
//

import SwiftUI
import Combine
import UniformTypeIdentifiers

let device = UIDevice.current
let fm = FileManager.default
var weOnADebugBuild = false
var pipe = Pipe()
var sema = DispatchSemaphore(value: 0)

@main
struct AsteroidApp: App {
    @StateObject private var mgr = AsteroidManager.shared
    @State private var currentTab = 0

    init() {
        setvbuf(stdout, nil, _IONBF, 0)
        UserDefaults.standard.register(defaults: ["mgWriteAtomically": true, "appHaptics": true])
        dup2(pipe.fileHandleForWriting.fileDescriptor, STDOUT_FILENO)
        
        // fix file picker
        let fixMethod = class_getInstanceMethod(UIDocumentPickerViewController.self, #selector(UIDocumentPickerViewController.fix_init(forOpeningContentTypes:asCopy:)))!
        let origMethod = class_getInstanceMethod(UIDocumentPickerViewController.self, #selector(UIDocumentPickerViewController.init(forOpeningContentTypes:asCopy:)))!
        method_exchangeImplementations(origMethod, fixMethod)
        
        #if DEBUG
        weOnADebugBuild = true
        #else
        weOnADebugBuild = false
        #endif
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                ContentView()
                    .tabItem {
                        Label("Home", systemImage: "house")
                    }
                    .id(0)
                TweaksView()
                    .tabItem {
                        Label("More Tweaks", systemImage: "wrench.and.screwdriver")
                    }
                    .id(1)
                DownloadablesView()
                    .tabItem {
                        Label("Downloadables", systemImage: "arrow.down.circle")
                    }
                    .id(2)
                RevertsView()
                    .tabItem {
                        Label("Reverts", systemImage: "arrow.uturn.backward.circle")
                    }
                    .id(3)
                FMRootView()
                    .tabItem {
                        Label("File Browser", systemImage: "folder")
                    }
                    .id(4)
            }
            .tint(.orange)
            .environmentObject(mgr)
            .onAppear {
                pipe.fileHandleForReading.readabilityHandler = { fh in
                    let data = fh.availableData
                    
                    if data.isEmpty {
                        fh.readabilityHandler = nil
                        sema.signal()
                        return
                    }
                    
                    guard let text = String(data: data, encoding: .utf8) else {
                        return
                    }
                    
                    DispatchQueue.main.async {
                        mgr.logOutput.append(text)
                    }
                }
                print("")
                print("[*] Asteroid v\(AppInfo.appVersion) (\(AppInfo.appBuild))")
                print("[*] Running on \(UIDevice.current.systemName) \(UIDevice.current.systemVersion), \(machineName())")
                if !isSupported() && !weOnADebugBuild {
                    Alertinator.shared.alert(title: "Your \(device.systemName) version is not supported!", body: AppMsg.unsupported, showCancel: false, actionLabel: "Exit", action: { exitinator() })
                }
            }
            .overlay {
                if mgr.shouldRespring {
                    RespringView()
                        .brightness(-1.0)
                        .ignoresSafeArea()
                }
            }
        }
    }
}

extension UIDocumentPickerViewController {
    @objc func fix_init(forOpeningContentTypes contentTypes: [UTType], asCopy: Bool) -> UIDocumentPickerViewController {
        return fix_init(forOpeningContentTypes: contentTypes, asCopy: true)
    }
}