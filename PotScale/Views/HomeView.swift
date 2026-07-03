import SwiftUI

struct HomeView: View {
    @Binding var path: NavigationPath

    var body: some View {
        ZStack {
            Theme.backgroundGradient.ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 32) {
                    // Header
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("PotScale")
                                .font(AppFont.display(34))
                                .foregroundColor(Theme.textPrimary)
                            Text("Scale any recipe to your pot")
                                .font(AppFont.body())
                                .foregroundColor(Theme.textSecondary)
                        }
                        Spacer()
                        ZStack {
                            Circle()
                                .fill(Theme.accentDim)
                                .frame(width: 44, height: 44)
                            Image(systemName: "person.crop.circle")
                                .font(.system(size: 22))
                                .foregroundColor(Theme.accent)
                        }
                    }
                    .padding(.top, 8)

                    // Primary CTA
                    Button {
                        path.append(Route.recipePicker)
                    } label: {
                        SurfaceCard {
                            VStack(alignment: .leading, spacing: 16) {
                                HStack {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 14)
                                            .fill(Theme.accentDim)
                                            .frame(width: 52, height: 52)
                                        Image(systemName: "fork.knife.circle.fill")
                                            .font(.system(size: 28))
                                            .foregroundColor(Theme.accent)
                                    }
                                    Spacer()
                                    Image(systemName: "arrow.right")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(Theme.accent)
                                }

                                VStack(alignment: .leading, spacing: 6) {
                                    Text("Choose a Recipe")
                                        .font(AppFont.heading(24))
                                        .foregroundColor(Theme.textPrimary)
                                    Text("Browse \(MockData.recipes.count) recipes and scale them perfectly to your pot.")
                                        .font(AppFont.body(15))
                                        .foregroundColor(Theme.textSecondary)
                                        .fixedSize(horizontal: false, vertical: true)
                                }

                                HStack(spacing: 8) {
                                    Image(systemName: "sparkles")
                                        .font(.system(size: 12, weight: .semibold))
                                    Text("Tap to get started")
                                        .font(AppFont.caption(13, weight: .semibold))
                                }
                                .foregroundColor(Theme.accent)
                            }
                            .padding(Theme.marginLarge)
                        }
                    }
                    .buttonStyle(.plain)

                    // Secondary cards
                    HStack(spacing: 12) {
                        SecondaryCard(
                            title: "My Recipes",
                            subtitle: "Saved",
                            icon: "heart.fill",
                            count: "0"
                        ) {
                            path.append(Route.myRecipes)
                        }

                        SecondaryCard(
                            title: "Recent Scans",
                            subtitle: "History",
                            icon: "clock.fill",
                            count: "3"
                        ) {
                            path.append(Route.myRecipes)
                        }
                    }

                    // Recent recipes teaser
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Popular Recipes")
                            .font(AppFont.subheading(18))
                            .foregroundColor(Theme.textPrimary)

                        ForEach(MockData.recipes.prefix(3)) { recipe in
                            RecipeCard(recipe: recipe) {
                                path.append(Route.recipeDetail(recipe))
                            }
                        }
                    }
                }
                .padding(.horizontal, Theme.margin)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
    }
}

private struct SecondaryCard: View {
    let title: String
    let subtitle: String
    let icon: String
    let count: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            SurfaceCard {
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Theme.accentDim)
                                .frame(width: 36, height: 36)
                            Image(systemName: icon)
                                .font(.system(size: 16))
                                .foregroundColor(Theme.accent)
                        }
                        Spacer()
                        Text(count)
                            .font(AppFont.display(22))
                            .foregroundColor(Theme.textPrimary)
                    }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(title)
                            .font(AppFont.label(14))
                            .foregroundColor(Theme.textPrimary)
                        Text(subtitle)
                            .font(AppFont.caption(12))
                            .foregroundColor(Theme.textSecondary)
                    }
                }
                .padding(Theme.gapL)
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    HomeView(path: $path)
}
