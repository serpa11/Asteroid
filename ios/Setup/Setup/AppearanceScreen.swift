import SwiftUI
import UIKit

struct AppearanceScreen: View {
    @Binding var selection: AppearanceChoice
    let onBack: () -> Void
    let onContinue: () -> Void

    var body: some View {
        SetupInfoScreen(
            onBack: onBack,
            icon: AnyView(DisplayAppearanceIcon()),
            title: "Display Appearance",
            text: "Choose the display appearance you'd prefer.",
            primaryTitle: "Continue",
            primaryAction: onContinue,
            content: AnyView(
                SetupRowGroup {
                    SetupRadioRow(title: "Light", isSelected: selection == .light) {
                        selection = .light
                    }
                    Divider()
                    SetupRadioRow(title: "Dark", isSelected: selection == .dark) {
                        selection = .dark
                    }
                }
            )
        )
    }
}
