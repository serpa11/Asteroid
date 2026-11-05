import SwiftUI

struct RegionScreen: View {
    @Binding var selection: String
    let onBack: () -> Void
    let onContinue: () -> Void

    var body: some View {
        SetupPickerList(items: SetupData.regions, onBack: onBack) { name in
            selection = name
            onContinue()
        }
    }
}
