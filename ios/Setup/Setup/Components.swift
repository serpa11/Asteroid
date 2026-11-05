import SwiftUI
import UIKit

// MARK: - Wallpaper

/// The setup wallpaper. Only the hello and welcome screens use it.
struct WallpaperImage: View {
    static let image: UIImage = {
        if let url = Bundle.main.url(forResource: "setupimage", withExtension: "jpeg"),
           let image = UIImage(contentsOfFile: url.path) {
            return image
        }
        return UIImage()
    }()

    var body: some View {
        Image(uiImage: Self.image)
            .resizable()
            .scaledToFill()
    }
}

// MARK: - Layout scaffold

struct SetupScaffold<Header: View, Content: View, Footer: View>: View {
    private let showBack: Bool
    private let onBack: () -> Void
    private let header: Header
    private let content: Content
    private let footer: Footer

    init(
        showBack: Bool = false,
        onBack: @escaping () -> Void = {},
        @ViewBuilder header: @escaping () -> Header,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder footer: @escaping () -> Footer
    ) {
        self.showBack = showBack
        self.onBack = onBack
        self.header = header()
        self.content = content()
        self.footer = footer()
    }

    var body: some View {
        ZStack {
            Color(.systemBackground)
                .ignoresSafeArea()

            VStack(spacing: 0) {
                if showBack {
                    HStack {
                        BackButton(action: onBack)
                        Spacer(minLength: 0)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 6)
                }

                header
                    .padding(.top, showBack ? 16 : 56)

                content

                footer
                    .padding(.horizontal, 24)
                    .padding(.top, 12)
                    .padding(.bottom, 20)
            }
        }
    }
}

// MARK: - Chrome

struct BackButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.system(size: 20, weight: .semibold))
                .foregroundStyle(Color.primary)
                .frame(width: 40, height: 40)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct PrimaryButton: View {
    let title: String
    var isEnabled: Bool = true
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
                .background(
                    Capsule()
                        .fill(Color.blue.opacity(isEnabled ? 0.90 : 0.45))
                )
                .glassSurface(Capsule())
                .opacity(isEnabled ? 1 : 0.72)
        }
        .buttonStyle(.plain)
        .disabled(!isEnabled)
    }
}

struct SetupTitle: View {
    let text: String
    var centered: Bool = false

    var body: some View {
        Text(text)
            .font(.system(size: 31, weight: .bold))
            .foregroundStyle(Color.primary)
            .multilineTextAlignment(centered ? .center : .leading)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: centered ? .center : .leading)
            .padding(.horizontal, 24)
    }
}

struct SetupBodyText: View {
    let text: String
    var centered: Bool = false

    var body: some View {
        Text(text)
            .font(.system(size: 16))
            .foregroundStyle(Color.secondary)
            .multilineTextAlignment(centered ? .center : .leading)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: centered ? .center : .leading)
            .padding(.horizontal, centered ? 34 : 24)
    }
}

// MARK: - Controls

struct SetupSearchField: View {
    @Binding var text: String
    var placeholder: String = "Search"

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.secondary)

            TextField(placeholder, text: $text)
                .font(.system(size: 17))
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)

            if !text.isEmpty {
                Button {
                    text = ""
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(Color.secondary)
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, 12)
        .frame(height: 40)
        .background(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .glassSurface(RoundedRectangle(cornerRadius: 12, style: .continuous))
        .padding(.horizontal, 16)
    }
}

struct SelectionRow: View {
    let title: String
    var subtitle: String? = nil
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 17))
                        .foregroundStyle(Color.primary)
                    if let subtitle {
                        Text(subtitle)
                            .font(.system(size: 13))
                            .foregroundStyle(Color.secondary)
                    }
                }
                Spacer(minLength: 12)
                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Color.blue)
                }
            }
            .padding(.horizontal, 24)
            .frame(minHeight: 50)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct OptionCard: View {
    let title: String
    let subtitle: String
    let symbol: String
    let isSelected: Bool
    let action: () -> Void

    private var shape: RoundedRectangle {
        RoundedRectangle(cornerRadius: 18, style: .continuous)
    }

    var body: some View {
        Button(action: action) {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: symbol)
                    .font(.system(size: 21, weight: .medium))
                    .foregroundStyle(Color.blue)
                    .frame(width: 36, height: 36)
                    .background(
                        RoundedRectangle(cornerRadius: 9, style: .continuous)
                            .fill(Color.blue.opacity(0.14))
                    )

                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color.primary)
                        .fixedSize(horizontal: false, vertical: true)
                    Text(subtitle)
                        .font(.system(size: 14))
                        .foregroundStyle(Color.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }

                Spacer(minLength: 6)

                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 21))
                    .foregroundStyle(isSelected ? Color.blue : Color.secondary.opacity(0.45))
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.secondarySystemBackground), in: shape)
            .overlay {
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .strokeBorder(isSelected ? Color.blue : Color.clear, lineWidth: 2)
            }
            .glassSurface(shape)
        }
        .buttonStyle(.plain)
    }
}

struct SummaryRow: View {
    let label: String
    let value: String

    var body: some View {
        HStack {
            Text(label)
                .font(.system(size: 15))
                .foregroundStyle(Color.secondary)
            Spacer(minLength: 16)
            Text(value)
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(Color.primary)
                .lineLimit(1)
                .truncationMode(.tail)
        }
        .padding(.horizontal, 16)
        .frame(minHeight: 46)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
        .glassSurface(RoundedRectangle(cornerRadius: 14, style: .continuous))
    }
}
