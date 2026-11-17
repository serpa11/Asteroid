//
//  MGControlBar.swift
//  Asteroid
//

import SwiftUI

// The bottom "MG Control" bar. It puts the actions that used to need scrolling
// all the way up the Home page - respring, logs and the quick MobileGestalt
// toggles - in one control-centre style strip above the tab bar.
struct MGControlBar: View {
    @StateObject private var store = GestaltStore.shared
    @EnvironmentObject private var mgr: AsteroidManager
    @Binding var showLogs: Bool
    @State private var showControl = false

    var body: some View {
        HStack(spacing: 8) {
            barButton(symbol: "command", title: "Logs") {
                showLogs = true
            }

            barButton(symbol: "arrow.clockwise", title: "Respring") {
                mgr.requestRespring()
            }

            barButton(symbol: "controlcenter", title: "MG Control") {
                showControl = true
            }

            NavigationLink {
                LogView()
            } label: {
                VStack(spacing: 3) {
                    Image(systemName: "doc.plaintext")
                    Text("Output").font(.caption2)
                }
                .frame(maxWidth: .infinity)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 10)
        .background(.ultraThinMaterial, in: .rect(cornerRadius: 26))
        .padding(.horizontal, 16)
        .padding(.bottom, 6)
        .sheet(isPresented: $showControl) {
            MGControlSheet()
        }
    }

    private func barButton(symbol: String, title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 3) {
                Image(systemName: symbol)
                Text(title).font(.caption2)
            }
            .frame(maxWidth: .infinity)
        }
        .buttonStyle(.plain)
        .foregroundStyle(Color.accentColor)
    }
}

// Quick MobileGestalt toggles, so the common capability flips do not need the
// Home page at all.
struct MGControlSheet: View {
    @StateObject private var store = GestaltStore.shared
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            List {
                Section {
                    PlainToggle("Enable Dynamic Island", minVrs: 19.0, isOn: store.mgKeyBinding([MGKey.island]))
                    PlainToggle("Enable AOD", minVrs: 18.0, isOn: store.mgKeyBinding([MGKey.AOD, MGKey.AOTime]))
                    PlainToggle("Enable Charge Limit", minVrs: 17.0, isOn: store.mgKeyBinding([MGKey.chargeLim]))
                    PlainToggle("Enable Boot Chime", isOn: store.mgKeyBinding([MGKey.bootChime]))
                } header: {
                    HeaderLabel("Quick Toggles", symbol: "togglepower")
                } footer: {
                    Text("These write the same MobileGestalt keys as the Home page. Press Apply there to save them.")
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(UIColor.systemBackground))
            .navigationTitle("MG Control")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        ToolbarLabel("Close", symbol: "xmark")
                    }
                }
            }
        }
    }
}
