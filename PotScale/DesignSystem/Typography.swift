import SwiftUI

enum AppFont {
    static func display(_ size: CGFloat, weight: Font.Weight = .bold) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }

    static func heading(_ size: CGFloat = 28, weight: Font.Weight = .bold) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }

    static func subheading(_ size: CGFloat = 20, weight: Font.Weight = .semibold) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }

    static func body(_ size: CGFloat = 16, weight: Font.Weight = .regular) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }

    static func caption(_ size: CGFloat = 13, weight: Font.Weight = .medium) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }

    static func label(_ size: CGFloat = 15, weight: Font.Weight = .semibold) -> Font {
        .system(size: size, weight: weight, design: .rounded)
    }
}

// MARK: - Text style modifiers
extension Text {
    func displayStyle() -> Text {
        self.font(AppFont.display(34)).foregroundColor(Theme.textPrimary)
    }

    func headingStyle() -> Text {
        self.font(AppFont.heading(28)).foregroundColor(Theme.textPrimary)
    }

    func subheadingStyle() -> Text {
        self.font(AppFont.subheading()).foregroundColor(Theme.textPrimary)
    }

    func bodyStyle() -> Text {
        self.font(AppFont.body()).foregroundColor(Theme.textSecondary)
    }

    func captionStyle() -> Text {
        self.font(AppFont.caption()).foregroundColor(Theme.textSecondary)
    }
}
