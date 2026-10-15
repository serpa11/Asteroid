import SwiftUI

struct SettingsView: View {
    @AppStorage("baseURL") private var baseURL = "https://api.openai.com/v1"
    @AppStorage("apiKey") private var apiKey = ""
    @AppStorage("model") private var model = "gpt-4o-mini"
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            Form {
                Section("Connection") {
                    TextField("Base URL", text: $baseURL)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                    SecureField("API Key", text: $apiKey)
                    TextField("Model", text: $model)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                }
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        ChatService.shared.baseURL = baseURL
                        ChatService.shared.apiKey = apiKey
                        ChatService.shared.model = model
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            ChatService.shared.baseURL = baseURL
            ChatService.shared.apiKey = apiKey
            ChatService.shared.model = model
        }
    }
}
