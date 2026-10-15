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
                    NavigationLink("Tendies", destination: PosterBoardView())
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
