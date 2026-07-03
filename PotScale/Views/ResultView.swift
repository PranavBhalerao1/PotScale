import SwiftUI

struct ResultView: View {
    let result: ScaledResult
    @Binding var path: NavigationPath
    @State private var saved = false

    var scalePct: String {
        let pct = (result.scaleFactor - 1) * 100
        let sign = pct >= 0 ? "+" : ""
        return "\(sign)\(Int(pct))%"
    }

    var body: some View {
        ZStack(alignment: .bottom) {
            Theme.backgroundGradient.ignoresSafeArea()

            ScrollView {
                VStack(spacing: 24) {
                    // Header card
                    SurfaceCard {
                        VStack(spacing: 12) {
                            HStack(spacing: 16) {
                                // Original
                                VStack(spacing: 4) {
                                    Text("Original")
                                        .font(AppFont.caption())
                                        .foregroundColor(Theme.textSecondary)
                                    Text("\(result.recipe.suggestedPotQuarts.formatted(.number.precision(.fractionLength(0...1)))) qt")
                                        .font(AppFont.heading(22))
                                        .foregroundColor(Theme.textPrimary)
                                }
                                .frame(maxWidth: .infinity)

                                // Arrow + scale factor
                                VStack(spacing: 4) {
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 14, weight: .bold))
                                        .foregroundColor(Theme.accent)
                                    Text(scalePct)
                                        .font(AppFont.caption(12, weight: .bold))
                                        .foregroundColor(result.scaleFactor >= 1 ? Theme.accent : Theme.destructive)
                                }

                                // Detected
                                VStack(spacing: 4) {
                                    Text("Your Pot")
                                        .font(AppFont.caption())
                                        .foregroundColor(Theme.textSecondary)
                                    Text("\(result.detectedQuarts.formatted(.number.precision(.fractionLength(1)))) qt")
                                        .font(AppFont.heading(22))
                                        .foregroundColor(Theme.accent)
                                }
                                .frame(maxWidth: .infinity)
                            }

                            Divider().background(Theme.border)

                            Text(result.recipe.title)
                                .font(AppFont.label(14))
                                .foregroundColor(Theme.textSecondary)
                        }
                        .padding(Theme.marginLarge)
                    }
                    .padding(.horizontal, Theme.margin)

                    // Column headers
                    HStack {
                        Text("Ingredient")
                            .font(AppFont.caption(12, weight: .semibold))
                            .foregroundColor(Theme.textSecondary)
                            .frame(maxWidth: .infinity, alignment: .leading)
                        Text("Original")
                            .font(AppFont.caption(12, weight: .semibold))
                            .foregroundColor(Theme.textSecondary)
                            .frame(width: 80, alignment: .trailing)
                        Text("Scaled")
                            .font(AppFont.caption(12, weight: .semibold))
                            .foregroundColor(Theme.accent)
                            .frame(width: 80, alignment: .trailing)
                    }
                    .padding(.horizontal, Theme.margin)

                    // Ingredient rows
                    VStack(spacing: 0) {
                        ForEach(Array(result.scaledIngredients.enumerated()), id: \.offset) { idx, pair in
                            ScaledIngredientRow(
                                pair: pair,
                                isLast: idx == result.scaledIngredients.count - 1
                            )
                        }
                    }
                    .background(Theme.surface)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radiusM))
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.radiusM)
                            .stroke(Theme.border, lineWidth: 1)
                    )
                    .padding(.horizontal, Theme.margin)
                    .cardShadow()

                    // Note
                    HStack(spacing: 6) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 12))
                        Text("Quantities scaled by a factor of \(result.scaleFactor.formatted(.number.precision(.fractionLength(2))))×")
                            .font(AppFont.caption(12))
                    }
                    .foregroundColor(Theme.textSecondary)
                    .padding(.horizontal, Theme.margin)

                    Spacer(minLength: 100)
                }
                .padding(.top, 16)
            }

            // Sticky bottom
            VStack(spacing: 0) {
                Divider().background(Theme.border)
                VStack(spacing: 10) {
                    PrimaryButton(
                        saved ? "Saved!" : "Save to My Recipes",
                        icon: saved ? "checkmark" : "heart.fill"
                    ) {
                        withAnimation(.spring(response: 0.3)) { saved = true }
                    }
                    if saved {
                        Button {
                            path = NavigationPath()
                        } label: {
                            Text("Back to Home")
                                .font(AppFont.caption(14))
                                .foregroundColor(Theme.textSecondary)
                        }
                        .transition(.opacity)
                    }
                }
                .padding(.horizontal, Theme.margin)
                .padding(.vertical, 16)
                .background(.ultraThinMaterial)
            }
        }
        .navigationTitle("Scaled Recipe")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private struct ScaledIngredientRow: View {
    let pair: (original: Ingredient, scaled: Ingredient)
    let isLast: Bool

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 8) {
                Text(pair.original.name)
                    .font(AppFont.body(15))
                    .foregroundColor(Theme.textPrimary)
                    .lineLimit(2)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text("\(pair.original.formattedQuantity) \(pair.original.unit)")
                    .font(AppFont.caption(13))
                    .foregroundColor(Theme.textSecondary)
                    .frame(width: 80, alignment: .trailing)
                    .lineLimit(1)

                Text("\(pair.scaled.formattedQuantity) \(pair.scaled.unit)")
                    .font(AppFont.label(13))
                    .foregroundColor(Theme.accent)
                    .frame(width: 80, alignment: .trailing)
                    .lineLimit(1)
            }
            .padding(.horizontal, Theme.gapL)
            .padding(.vertical, 12)

            if !isLast {
                Divider()
                    .background(Theme.border)
                    .padding(.horizontal, Theme.gapL)
            }
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    let result = ScaledResult(recipe: MockData.recipes[0], detectedQuarts: 4.5)
    NavigationStack {
        ResultView(result: result, path: $path)
    }
    .preferredColorScheme(.dark)
}
