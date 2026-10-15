//
//  TerminalPlatter.swift
//  PartyUI
//
//  Created by lunginspector on 3/3/26.
//

import SwiftUI

var terminalRad: CGFloat {
    if #available(iOS 19.0, *) { return 22 } else { return 14 }
}

struct TerminalPlatter: ViewModifier {
    func body(content: Content) -> some View {
        content
            .frame(height: 250)
            .padding(.horizontal)
            .background(LinearGradient(colors: [Color(red: 0.06, green: 0.08, blue: 0.10), Color(UIColor.systemBackground)], startPoint: .topLeading, endPoint: .bottomTrailing), in: .rect(cornerRadius: terminalRad))
            .overlay(RoundedRectangle(cornerRadius: terminalRad).stroke(appAccentColor().opacity(0.45)))
    }
}
