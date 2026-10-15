import SwiftUI

struct ConversationListView: View {
    @StateObject private var store = ConversationStore()
    @State private var showChat = false
    @State private var selectedConversationID: UUID?

    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.ignoresSafeArea()

                List {
                    if store.conversations.isEmpty {
                        Text("No conversations yet")
                            .foregroundStyle(.secondary)
                            .listRowBackground(Color.clear)
                    } else {
                        ForEach(store.conversations) { conversation in
                            NavigationLink(value: conversation.id) {
                                HStack(spacing: 12) {
                                    Image(systemName: "message")
                                        .foregroundStyle(.blue)
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(conversation.title)
                                            .foregroundStyle(.white)
                                            .font(.headline)
                                            .lineLimit(1)
                                        if let last = conversation.messages.last {
                                            Text(last.content)
                                                .foregroundStyle(.secondary)
                                                .font(.subheadline)
                                                .lineLimit(2)
                                        } else {
                                            Text("Empty conversation")
                                                .foregroundStyle(.secondary)
                                                .font(.subheadline)
                                        }
                                    }
                                    Spacer()
                                }
                                .padding(.vertical, 6)
                            }
                            .listRowBackground(Color.clear)
                        }
                        .onDelete { store.delete(at: $0) }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .navigationTitle("Siri")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        let conv = store.createConversation()
                        selectedConversationID = conv.id
                        showChat = true
                    } label: {
                        Image(systemName: "square.and.pencil")
                            .font(.title3)
                            .foregroundStyle(.white)
                    }
                }
            }
            .navigationDestination(isPresented: $showChat) {
                if let id = selectedConversationID {
                    ChatView(conversationID: id)
                        .environmentObject(store)
                }
            }
            .navigationDestination(for: UUID.self) { id in
                ChatView(conversationID: id)
                    .environmentObject(store)
            }
        }
        .environmentObject(store)
    }
}

struct ChatView: View {
    let conversationID: UUID
    @EnvironmentObject private var store: ConversationStore
    @State private var input = ""
    @State private var isThinking = false
    @State private var showSettings = false
    @Environment(\.dismiss) private var dismiss

    private var conversation: Conversation? {
        store.conversations.first { $0.id == conversationID }
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            VStack(spacing: 0) {
                if let conversation {
                    ScrollViewReader { proxy in
                        ScrollView {
                            LazyVStack(spacing: 14) {
                                ForEach(conversation.messages) { message in
                                    bubble(message)
                                        .id(message.id)
                                }
                                if isThinking { thinkingIndicator }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                        }
                        .onChange(of: conversation.messages.count) { _ in
                            withAnimation { proxy.scrollTo(conversation.messages.last?.id, anchor: .bottom) }
                        }
                    }
                }

                inputBar
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button { dismiss() } label: {
                    Image(systemName: "chevron.backward")
                        .foregroundStyle(.white)
                }
            }
            ToolbarItem(placement: .topBarTrailing) {
                Button { showSettings = true } label: {
                    Image(systemName: "gearshape")
                        .foregroundStyle(.white)
                }
            }
        }
        .sheet(isPresented: $showSettings) { SettingsView() }
    }

    private func bubble(_ message: ChatMessage) -> some View {
        HStack {
            if message.role == .user { Spacer() }
            Text(message.content)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .foregroundStyle(.white)
                .background(
                    message.role == .user
                        ? AnyShapeStyle(LinearGradient(colors: [.blue, .indigo], startPoint: .topLeading, endPoint: .bottomTrailing))
                        : AnyShapeStyle(Color.white.opacity(0.08)),
                    in: RoundedRectangle(cornerRadius: 22, style: .continuous)
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(.white.opacity(0.12), lineWidth: 1)
                )
                .frame(maxWidth: 300, alignment: message.role == .user ? .trailing : .leading)
            if message.role != .user { Spacer() }
        }
    }

    private var thinkingIndicator: some View {
        HStack {
            Text("…")
                .font(.title2)
                .foregroundStyle(.white.opacity(0.7))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(Color.white.opacity(0.08), in: RoundedRectangle(cornerRadius: 22, style: .continuous))
            Spacer()
        }
    }

    private var inputBar: some View {
        HStack(spacing: 10) {
            TextField("Ask Siri", text: $input)
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .foregroundStyle(.white)
                .background(Color.white.opacity(0.1), in: Capsule())
                .overlay(Capsule().stroke(.white.opacity(0.15), lineWidth: 1))
                .onSubmit { send() }

            Button(action: send) {
                Image(systemName: "arrow.up.circle.fill")
                    .font(.system(size: 34))
                    .foregroundStyle(input.trimmingCharacters(in: .whitespaces).isEmpty ? .gray : .blue)
            }
            .disabled(input.trimmingCharacters(in: .whitespaces).isEmpty || isThinking)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .modify { view in
            if #available(iOS 26, *) {
                view.glassEffect(.regular, in: Capsule())
            } else {
                view.background(.ultraThinMaterial, in: Capsule())
            }
        }
    }

    private func send() {
        let text = input.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !text.isEmpty else { return }
        let userMsg = ChatMessage(role: .user, content: text)
        store.addMessage(userMsg, to: conversationID)
        input = ""
        isThinking = true

        Task {
            do {
                let history = conversation?.messages ?? []
                let reply = try await ChatService.shared.send(messages: history)
                store.addMessage(ChatMessage(role: .assistant, content: reply.isEmpty ? "I didn't get a response." : reply), to: conversationID)
            } catch {
                store.addMessage(ChatMessage(role: .assistant, content: "Error: \(error.localizedDescription)"), to: conversationID)
            }
            isThinking = false
        }
    }
}

struct SiriAIAppPlaceholder { }

extension View {
    func modify<T: View>(@ViewBuilder _ transform: (Self) -> T) -> T { transform(self) }

    @ViewBuilder
    func siriGlass() -> some View {
        if #available(iOS 26, *) {
            self.glassEffect(.regular, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        } else {
            self.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
    }

    @ViewBuilder
    func siriGlassStatic() -> some View { self }
}