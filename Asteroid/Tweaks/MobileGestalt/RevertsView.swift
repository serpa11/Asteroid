import SwiftUI

struct RevertsView: View {
    @EnvironmentObject private var mgr: AsteroidManager
    @StateObject private var store = GestaltStore.shared
    @AppStorage("mgSiriAI") private var mgSiriAI = false
    @AppStorage("mgSiriAISpoof") private var mgSiriAISpoof = "iPhone17,1"
    @State private var mgClassicIntell = false

    var body: some View {
        NavigationStack {
            List {
                Section {
                    HStack(alignment: .top, spacing: 12) {
                        Image(systemName: "arrow.uturn.backward.circle")
                            .imageScale(.large)
                            .frame(width: 28)
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Revert back to Old Siri pre-Apple Intelligence")
                                .font(.headline)
                            Text("This will disable Apple Intelligence and Siri AI on your modern iPhone. To restore them, enable Classic Apple Intelligence from the options above.")
                                .font(.footnote)
                                .foregroundStyle(.secondary)
                            Button("Revert now") {
                                revertToOldSiri()
                            }
                            .buttonStyle(ConfirmButtonStyle())
                        }
                    }
                } header: {
                    HeaderLabel("Revert to Old Siri", symbol: "arrow.uturn.backward.circle")
                }
            }
            .navigationTitle("Reverts")
            .scrollContentBackground(.hidden)
            .background(Color(UIColor.systemBackground))
            .onAppear {
                guard let dict = NSMutableDictionary(contentsOf: MGURL.fsGestaltURL) else { return }
                store.mgCurrentDict = dict
                mgSiriAI = store.strVal(forKey: "h63QSdBCiT/z0WU6rdQv6Q") == "LL"
                    && store.cacheExtra["A62OafQ85EJAiiqKn4agtg"] as? Int == 1
                mgClassicIntell = !mgSiriAI && store.cacheExtra["A62OafQ85EJAiiqKn4agtg"] as? Int == 1
            }
        }
    }

    private func revertToOldSiri() {
        Task { @MainActor in
            mgSiriAI = false
            mgClassicIntell = false
            let result = store.mgSafelyApplySiriAIChange(enabled: false, spoof: mgSiriAISpoof)
            if result.succeeded {
                Haptic.shared.play(.soft)
                Alertinator.shared.alert(title: "Asteroid", body: result.message, actionLabel: "Respring", action: { mgr.shouldRespring = true })
            } else {
                Alertinator.shared.alert(title: "Failed to remove Siri AI!", body: result.message)
            }
        }
    }
}