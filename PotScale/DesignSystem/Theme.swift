import SwiftUI

enum Theme {
    // MARK: - Colors
    static let background = Color(hex: "0A0A0B")
    static let surface = Color(hex: "1A1A1C")
    static let border = Color(hex: "2A2A2D")
    static let accent = Color(hex: "3B82F6")
    static let accentDim = Color(hex: "3B82F6").opacity(0.15)
    static let textPrimary = Color.white
    static let textSecondary = Color(hex: "9CA3AF")
    static let destructive = Color(hex: "EF4444")

    // MARK: - Spacing
    static let margin: CGFloat = 20
    static let marginLarge: CGFloat = 24
    static let gapS: CGFloat = 8
    static let gapM: CGFloat = 12
    static let gapL: CGFloat = 16

    // MARK: - Radius
    static let radiusS: CGFloat = 10
    static let radiusM: CGFloat = 16
    static let radiusL: CGFloat = 20
    static let radiusFull: CGFloat = 100

    // MARK: - Shadows
    static var cardShadow: some View { Color.clear }
    static func cardShadowModifier() -> some ViewModifier { CardShadowModifier() }

    // MARK: - Gradients
    static let backgroundGradient = LinearGradient(
        colors: [Color(hex: "0A0A0B"), Color(hex: "0D1117")],
        startPoint: .top,
        endPoint: .bottom
    )

    static let accentGradient = LinearGradient(
        colors: [Color(hex: "3B82F6"), Color(hex: "6366F1")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let heroGradient = LinearGradient(
        colors: [Color(hex: "1E293B"), Color(hex: "0F172A")],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

private struct CardShadowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .shadow(color: Color.black.opacity(0.4), radius: 12, x: 0, y: 4)
            .shadow(color: Theme.accent.opacity(0.05), radius: 1, x: 0, y: 0)
    }
}

extension View {
    func cardShadow() -> some View {
        self.modifier(CardShadowModifier())
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3:
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6:
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8:
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
