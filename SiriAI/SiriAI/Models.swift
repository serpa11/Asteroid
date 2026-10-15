import Foundation

struct ChatMessage: Identifiable, Codable, Hashable {
    enum Role: String, Codable { case user, assistant, system }
    var id = UUID()
    var role: Role
    var content: String
    var timestamp = Date()
}

struct Conversation: Identifiable, Codable, Hashable {
    var id = UUID()
    var title: String
    var messages: [ChatMessage]
    var createdAt: Date
    var updatedAt: Date

    init(title: String = "New Chat", messages: [ChatMessage] = []) {
        self.id = UUID()
        self.title = title
        self.messages = messages
        self.createdAt = Date()
        self.updatedAt = Date()
    }
}

@MainActor
final class ConversationStore: ObservableObject {
    @Published var conversations: [Conversation] = []

    private let fileURL: URL = {
        let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return docs.appendingPathComponent("siri_conversations.json")
    }()

    init() { load() }

    func load() {
        guard FileManager.default.fileExists(atPath: fileURL.path) else { return }
        do {
            let data = try Data(contentsOf: fileURL)
            let decoded = try JSONDecoder().decode([Conversation].self, from: data)
            conversations = decoded.sorted { $0.updatedAt > $1.updatedAt }
        } catch {
            conversations = []
        }
    }

    func persist() {
        do {
            let data = try JSONEncoder().encode(conversations)
            try data.write(to: fileURL, options: [.atomic])
        } catch { }
    }

    func createConversation() -> Conversation {
        let c = Conversation()
        conversations.insert(c, at: 0)
        persist()
        return c
    }

    func addMessage(_ message: ChatMessage, to conversationID: UUID) {
        guard let i = conversations.firstIndex(where: { $0.id == conversationID }) else { return }
        conversations[i].messages.append(message)
        if conversations[i].title == "New Chat", message.role == .user {
            conversations[i].title = String(message.content.prefix(40))
        }
        conversations[i].updatedAt = Date()
        conversations.sort { $0.updatedAt > $1.updatedAt }
        persist()
    }

    func delete(at offsets: IndexSet) {
        conversations.remove(atOffsets: offsets)
        persist()
    }
}
