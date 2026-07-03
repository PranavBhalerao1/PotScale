import SwiftUI

struct RecipeDetailView: View {
    let recipe: Recipe
    @Binding var path: NavigationPath

    var body: some View {
        ZStack(alignment: .bottom) {
            Theme.backgroundGradient.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // Hero
                    ImagePlaceholder(height: 260, gradient: Theme.heroGradient)
                        .overlay(
                            LinearGradient(
                                colors: [Color.clear, Theme.background.opacity(0.8)],
                                startPoint: .center,
                                endPoint: .bottom
                            )
                        )
                        .ignoresSafeArea(edges: .top)

                    VStack(alignment: .leading, spacing: 20) {
                        // Title + badge
                        VStack(alignment: .leading, spacing: 10) {
                            HStack(alignment: .top) {
                                Text(recipe.title)
                                    .font(AppFont.display(30))
                                    .foregroundColor(Theme.textPrimary)
                                    .fixedSize(horizontal: false, vertical: true)
                                Spacer()
                            }
                            HStack(spacing: 10) {
                                PotSizeBadge(label: recipe.potBadge)
                                Label(recipe.subtitle, systemImage: "clock")
                                    .font(AppFont.caption())
                                    .foregroundColor(Theme.textSecondary)
                            }
                        }

                        // Description
                        Text(recipe.description)
                            .font(AppFont.body())
                            .foregroundColor(Theme.textSecondary)
                            .fixedSize(horizontal: false, vertical: true)

                        Divider()
                            .background(Theme.border)

                        // Ingredients
                        SectionHeader(title: "Ingredients", icon: "list.bullet")
                        VStack(spacing: 0) {
                            ForEach(Array(recipe.ingredients.enumerated()), id: \.element.id) { idx, ing in
                                IngredientRow(ingredient: ing, isLast: idx == recipe.ingredients.count - 1)
                            }
                        }
                        .background(Theme.surface)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.radiusM))
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.radiusM)
                                .stroke(Theme.border, lineWidth: 1)
                        )

                        // Instructions
                        SectionHeader(title: "Instructions", icon: "text.alignleft")
                        VStack(spacing: 12) {
                            ForEach(Array(recipe.steps.enumerated()), id: \.offset) { idx, step in
                                StepRow(number: idx + 1, text: step)
                            }
                        }
                    }
                    .padding(.horizontal, Theme.margin)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
            .ignoresSafeArea(edges: .top)

            // Sticky bottom CTA
            VStack(spacing: 0) {
                Divider().background(Theme.border)
                HStack {
                    PrimaryButton("Scan My Pot", icon: "camera.fill") {
                        path.append(Route.scanPot(recipe))
                    }
                }
                .padding(.horizontal, Theme.margin)
                .padding(.vertical, 16)
                .background(.ultraThinMaterial)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct SectionHeader: View {
    let title: String
    let icon: String

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Theme.accent)
            Text(title)
                .font(AppFont.subheading(18))
                .foregroundColor(Theme.textPrimary)
        }
    }
}

private struct IngredientRow: View {
    let ingredient: Ingredient
    let isLast: Bool

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text(ingredient.name)
                    .font(AppFont.body())
                    .foregroundColor(Theme.textPrimary)
                Spacer()
                Text("\(ingredient.formattedQuantity) \(ingredient.unit)")
                    .font(AppFont.label(15))
                    .foregroundColor(Theme.accent)
            }
            .padding(.horizontal, Theme.gapL)
            .padding(.vertical, 13)

            if !isLast {
                Divider()
                    .background(Theme.border)
                    .padding(.horizontal, Theme.gapL)
            }
        }
    }
}

private struct StepRow: View {
    let number: Int
    let text: String

    var body: some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                Circle()
                    .fill(Theme.accentDim)
                    .frame(width: 28, height: 28)
                Text("\(number)")
                    .font(AppFont.caption(13, weight: .bold))
                    .foregroundColor(Theme.accent)
            }
            Text(text)
                .font(AppFont.body())
                .foregroundColor(Theme.textSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    NavigationStack {
        RecipeDetailView(recipe: MockData.recipes[0], path: $path)
    }
    .preferredColorScheme(.dark)
}
