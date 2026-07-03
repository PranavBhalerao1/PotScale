import SwiftUI

// MARK: - Primary Button
struct PrimaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void

    init(_ title: String, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }

    @State private var isPressed = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                        .font(AppFont.label())
                }
                Text(title)
                    .font(AppFont.label(16))
            }
            .foregroundColor(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Theme.accentGradient)
            .clipShape(RoundedRectangle(cornerRadius: Theme.radiusFull))
            .scaleEffect(isPressed ? 0.97 : 1.0)
        }
        .buttonStyle(.plain)
        .simultaneousGesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in withAnimation(.spring(response: 0.2)) { isPressed = true } }
                .onEnded { _ in withAnimation(.spring(response: 0.3)) { isPressed = false } }
        )
    }
}

// MARK: - Secondary Button
struct SecondaryButton: View {
    let title: String
    let icon: String?
    let action: () -> Void

    init(_ title: String, icon: String? = nil, action: @escaping () -> Void) {
        self.title = title
        self.icon = icon
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if let icon {
                    Image(systemName: icon)
                        .font(AppFont.label())
                }
                Text(title)
                    .font(AppFont.label(15))
            }
            .foregroundColor(Theme.textPrimary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 15)
            .background(Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: Theme.radiusFull))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.radiusFull)
                    .stroke(Theme.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Image Placeholder
struct ImagePlaceholder: View {
    let height: CGFloat
    let gradient: LinearGradient

    init(height: CGFloat = 200, gradient: LinearGradient = Theme.heroGradient) {
        self.height = height
        self.gradient = gradient
    }

    var body: some View {
        ZStack {
            Rectangle()
                .fill(gradient)
            Image(systemName: "fork.knife")
                .font(.system(size: 36, weight: .light))
                .foregroundColor(Theme.border)
        }
        .frame(height: height)
    }
}

// MARK: - Category Chip
struct CategoryChip: View {
    let label: String
    let icon: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 5) {
                Text(icon)
                    .font(.system(size: 13))
                Text(label)
                    .font(AppFont.caption(13, weight: .semibold))
            }
            .foregroundColor(isSelected ? .white : Theme.textSecondary)
            .padding(.horizontal, 14)
            .padding(.vertical, 8)
            .background(
                isSelected
                    ? AnyView(Theme.accentGradient)
                    : AnyView(Theme.surface)
            )
            .clipShape(RoundedRectangle(cornerRadius: Theme.radiusFull))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.radiusFull)
                    .stroke(isSelected ? Color.clear : Theme.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Pot Size Badge
struct PotSizeBadge: View {
    let label: String

    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "flame.fill")
                .font(.system(size: 11, weight: .semibold))
            Text(label)
                .font(AppFont.caption(12, weight: .semibold))
        }
        .foregroundColor(Theme.accent)
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Theme.accentDim)
        .clipShape(RoundedRectangle(cornerRadius: Theme.radiusFull))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.radiusFull)
                .stroke(Theme.accent.opacity(0.3), lineWidth: 1)
        )
    }
}

// MARK: - Recipe Card
struct RecipeCard: View {
    let recipe: Recipe
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 14) {
                ImagePlaceholder(height: 72, gradient: Theme.heroGradient)
                    .frame(width: 72, height: 72)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radiusS))

                VStack(alignment: .leading, spacing: 4) {
                    Text(recipe.title)
                        .font(AppFont.label(15))
                        .foregroundColor(Theme.textPrimary)
                        .lineLimit(2)
                    Text(recipe.subtitle)
                        .font(AppFont.caption())
                        .foregroundColor(Theme.textSecondary)
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundColor(Theme.border)
            }
            .padding(Theme.gapL)
            .background(Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: Theme.radiusM))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.radiusM)
                    .stroke(Theme.border, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .cardShadow()
    }
}

// MARK: - Floating Action Button
struct FABButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 58, height: 58)
                .background(Theme.accentGradient)
                .clipShape(Circle())
                .shadow(color: Theme.accent.opacity(0.4), radius: 16, x: 0, y: 6)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Surface Card Container
struct SurfaceCard<Content: View>: View {
    let content: Content

    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    var body: some View {
        content
            .background(Theme.surface)
            .clipShape(RoundedRectangle(cornerRadius: Theme.radiusL))
            .overlay(
                RoundedRectangle(cornerRadius: Theme.radiusL)
                    .stroke(Theme.border, lineWidth: 1)
            )
            .cardShadow()
    }
}
