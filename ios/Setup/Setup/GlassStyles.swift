import SwiftUI
import UIKit

/// Liquid-glass surface used across the whole setup flow.
/// On iOS 26+ this is the real `glassEffect` material; on earlier systems it is a no-op.
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

struct GlassSurfaceModifier<S: Shape>: ViewModifier {
    let shape: S

    func body(content: Content) -> some View {
        if #available(iOS 26.0, *) {
            content.glassEffect(.regular, in: shape)
        } else {
            content
        }
    }
}

extension View {
    func glassSurface<S: Shape>(_ shape: S) -> some View {
        modifier(GlassSurfaceModifier(shape: shape))
    }
}
