import SwiftUI

struct RegionScreen: View {
    @Binding var selection: String
    let onBack: () -> Void
    let onContinue: () -> Void

    @State private var query = ""

    private var results: [String] {
        let all = SetupData.regions
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return all }
        return all.filter { $0.localizedCaseInsensitiveContains(trimmed) }
    }

    var body: some View {
        SetupScaffold(
            showBack: true,
            onBack: onBack,
            header: {
                VStack(alignment: .leading, spacing: 18) {
                    SetupTitle(text: "Select Your Country or Region")
                    SetupSearchField(text: $query, placeholder: "Search")
                }
            },
            content: {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(results, id: \.self) { name in
                            SelectionRow(title: name, isSelected: name == selection) {
                                selection = name
                            }
                            Divider()
                                .padding(.leading, 24)
                        }

                        if results.isEmpty {
                            Text("No Results")
                                .font(.system(size: 17, weight: .semibold))
                                .foregroundStyle(Color.secondary)
                                .frame(maxWidth: .infinity)
                                .padding(.top, 40)
                        }
                    }
                    .padding(.top, 6)
                }
            },
            footer: {
                PrimaryButton(title: "Continue", action: onContinue)
            }
        )
    }
}
