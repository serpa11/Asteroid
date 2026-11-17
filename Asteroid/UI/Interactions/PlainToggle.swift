//
//  PlainToggle.swift
//  PartyUI
//
//  Created by lunginspector on 3/8/26.
//

import SwiftUI

enum ToggleInfoType: Codable {
    case none, info, warning
}

struct PlainToggle: View {
    var text: String
    var icon: String
    var infoType: ToggleInfoType
    var infoTitle: String
    var infoMessage: String
    var minVrs: Double
    var maxVrs: Double
    /// Draws the leading icon in red. Used for the options that can take the
    /// device down (Liquid Glass removal and friends).
    var critical: Bool
    @Binding var isOn: Bool

    public init(_ text: String, icon: String = "", infoType: ToggleInfoType = .none, infoTitle: String = "Information", infoMessage: String = "", minVrs: Double = 0.0, maxVrs: Double = 100.0, critical: Bool = false, isOn: Binding<Bool>) {
        self.text = text
        self.icon = icon
        self.infoType = infoType
        self.infoTitle = infoTitle
        self.infoMessage = infoMessage
        self._isOn = isOn
        self.minVrs = minVrs
        self.maxVrs = maxVrs
        self.critical = critical
    }

    public var body: some View {
        if doubleSysVrs() >= minVrs && doubleSysVrs() <= maxVrs {
            Toggle(isOn: $isOn) {
                HStack(spacing: 10) {
                    if !icon.isEmpty {
                        Image(systemName: icon)
                            .frame(width: 22, height: 22, alignment: .center)
                            .foregroundStyle(critical ? Color.red : Color.accentColor)
                    }
                    Text(text)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .foregroundStyle(critical ? Color.red : Color.primary)
                    if infoType == .info || infoType == .warning {
                        Button(action: {
                            Alertinator.shared.alert(title: infoTitle, body: infoMessage)
                        }) {
                            Image(systemName: infoType == .info ? "info.circle" : "exclamationmark.triangle")
                                .foregroundStyle(critical ? Color.red : Color.accentColor)
                        }
                        .buttonStyle(.plain)
                        .padding(.trailing, 6)
                    }
                }
            }
            .tint(critical ? .red : .orange)
        }
    }
}
