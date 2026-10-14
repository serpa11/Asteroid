//
//  TweaksView.swift
//  Asteroid
//
//  Created by lunginspector on 8/26/26.
//

import SwiftUI


struct TweaksView: View {
    var body: some View {
        NavigationStack {
            List {
                Section {
                    NavigationLink("Custom Wallpapers", destination: PosterBoardView())
                    NavigationLink("Dialer Themer", destination: KeypadView())
                } header: {
                    HeaderLabel("Theming", symbol: "paintbrush")
                }
                
                Section {
                    if raveSupported() || weOnADebugBuild {
                        NavigationLink("Config Tweaks", destination: ConfigView())
                    }
                    NavigationLink("File Operations", destination: OperationsView())
                } header: {
                    HeaderLabel("System", symbol: "gear")
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color(UIColor.systemBackground))
            .navigationTitle("More Tweaks")
        }
    }
}
