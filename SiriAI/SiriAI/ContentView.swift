import SwiftUI

struct ContentView: View {
    @State private var messages: [ChatMessage] = [
        ChatMessage(role: .assistant, content: "Hi, I'm Siri. How can I help?")
    ]
    @State private var input = ""
    @State private var isThinking = false
    @State private var showSettings = false
    @State private var glow = false

    private let service = ChatService.shared

    var body: some View {
        ZStack {
            LinearGradient(colors: [.black, .indigo, .black], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                header

                ScrollViewReader { proxy in
                    ScrollView {
                        LazyVStack(spacing: 14) {
                            ForEach(messages) { message in
                                bubble(message)
                                    .id(message.id)
                            }
                            if isThinking {
                                thinkingIndicator
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                    .onChange(of: messages.count) { _ in
                        withAnimation { proxy.scrollTo(messages.last?.id, anchor: .bottom) }
                    }
                }

                inputBar
            }
        }
        .sheet(isPresented: $showSettings) { SettingsView() }
    }

    // MARK: Header
    private var header: some View {
        HStack {
            Text("Siri")
                .font(.system(size: 34, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
            Spacer()
            Button {
                showSettings = true
            } label: {
                Image(systemName: "gearshape")
                    .font(.title3)
                    .foregroundStyle(.white)
                    .padding(10)
                    .background(.ultraThinMaterial, in: Circle())
            }
        }
        .padding(.horizontal, 20)
        .padding(.top, 16)
        .padding(.bottom, 8)
    }

    // MARK: Bubble
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
                .frame(maxWidth: 280 * 1.1, alignment: message.role == .user ? .trailing : .leading)
            if message.role != .user { Spacer() }
        }
        .siriGlass()
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

    // MARK: Input
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
        messages.append(ChatMessage(role: .user, content: text))
        input = ""
        isThinking = true
        Task {
            do {
                let reply = try await service.send(messages: messages)
                messages.append(ChatMessage(role: .assistant, content: reply.isEmpty ? "I didn't get a response." : reply))
            } catch {
                messages.append(ChatMessage(role: .assistant, content: "Error: \(error.localizedDescription)"))
            }
            isThinking = false
        }
    }
}

extension View {
    func modify<T: View>(@ViewBuilder _ transform: (Self) -> T) -> T {
        transform(self)
    }
}

// Liquid-glass helper
extension View {
    @ViewBuilder
    func siriGlass() -> some View {
        if #available(iOS 26, *) {
            self.glassEffect(.regular, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        } else {
            self.background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 22, style: .continuous))
        }
    }
}
