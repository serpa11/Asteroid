//
//  HeaderLabel.swift
//  PartyUI
//
//  Created by lunginspector on 3/3/26.
//

import SwiftUI

struct HeaderLabel: View {
    var label: String
    var symbol: String
    @EnvironmentObject private var appearance: AppearanceStore

    init(_ label: String, symbol: String) {
        self.label = label
        self.symbol = symbol
    }

    var body: some View {
        if #available(iOS 19.0, *) {
            HStack(spacing: 10) {
                Image(systemName: symbol)
                    .frame(width: 22, alignment: .center)
                Text(label.uppercased())
                    .font(.caption.weight(appearance.highContrast ? .bold : .semibold).monospaced())
                    .foregroundStyle(Color.accentColor)
            }
        } else {
            HStack(spacing: 8) {
                Image(systemName: symbol)
                    .frame(width: 18, alignment: .center)
                Text(label)
            }
            .fontWeight(appearance.highContrast ? .bold : .regular)
        }
    }
}
