import Foundation

struct ChatMessage: Identifiable, Hashable {
    enum Role: String { case user, assistant, system }
    let id = UUID()
    let role: Role
    var content: String
    let timestamp = Date()
}

struct OpenAIChatResponse: Decodable {
    struct Choice: Decodable {
        struct Message: Decodable { let role: String; let content: String }
        let message: Message
    }
    let choices: [Choice]
}
