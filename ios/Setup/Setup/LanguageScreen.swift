import SwiftUI

/// The real iOS setup picker: plain back chevron, a search field, and a
/// full-width list with no title and no footer button. Tapping a row advances.
struct SetupPickerList: View {
    let items: [String]
    let onBack: () -> Void
    let onSelect: (String) -> Void

    @State private var query = ""

    private var results: [String] {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { return items }
        return items.filter { $0.localizedCaseInsensitiveContains(trimmed) }
    }

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                HStack {
                    BackButton(action: onBack)
                    Spacer(minLength: 0)
                }
                .padding(.horizontal, 16)
                .padding(.top, 6)

                SetupSearchField(text: $query)
                    .padding(.top, 6)

                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(results, id: \.self) { name in
                            Button {
                                onSelect(name)
                            } label: {
                                Text(name)
                                    .font(.system(size: 17))
                                    .foregroundStyle(Color.primary)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.horizontal, 20)
                                    .frame(height: 54)
                                    .contentShape(Rectangle())
                            }
                            .buttonStyle(.plain)

                            Divider()
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
            }
        }
    }
}

struct LanguageScreen: View {
    @Binding var selection: String
    let onBack: () -> Void
    let onContinue: () -> Void

    var body: some View {
        SetupPickerList(items: SetupData.languages, onBack: onBack) { name in
            selection = name
            onContinue()
        }
    }
}
