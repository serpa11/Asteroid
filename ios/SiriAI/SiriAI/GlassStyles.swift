import SwiftUI
import UIKit

struct GlassCircleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.title2)
            .foregroundStyle(Color.primary)
            .frame(width: 44, height: 44)
            .background(Color(.secondarySystemBackground))
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.94 : 1)
            .animation(.spring(response: 0.25), value: configuration.isPressed)
            .glassSurface(Circle())
    }
}

struct GlassMessageModifier: ViewModifier {
    let cornerRadius: CGFloat

    func body(content: Content) -> some View {
        content
            .background(Color(.secondarySystemBackground))
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
            .glassSurface(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

/// Liquid glass.
///
/// On iOS 26 and later this hands the view straight to the system `glassEffect`,
/// which is the genuine Apple material. On earlier systems the same three
/// ingredients are rebuilt by hand: a real `ultraThinMaterial` blur behind the
/// content, a directional white gloss, and a bright-to-dim rim stroke for the
/// refracted edge highlight, lifted off the background by a soft shadow.
struct GlassSurfaceModifier<S: InsettableShape>: ViewModifier {
    let shape: S

    private var rim: LinearGradient {
        LinearGradient(
            colors: [
                .white.opacity(0.90),
                .white.opacity(0.14),
                .white.opacity(0.58)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    private var gloss: LinearGradient {
        LinearGradient(
            colors: [
                .white.opacity(0.26),
                .white.opacity(0.03),
                .white.opacity(0.10)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content.glassEffect(.regular, in: shape)
        } else {
            content
                .background(Material.ultraThinMaterial, in: shape)
                .overlay { shape.strokeBorder(rim, lineWidth: 1) }
                .overlay { shape.fill(gloss) }
                .shadow(color: .black.opacity(0.24), radius: 16, y: 8)
        }
    }
}

extension View {
    func glassSurface<S: InsettableShape>(_ shape: S) -> some View {
        modifier(GlassSurfaceModifier(shape: shape))
    }
}
