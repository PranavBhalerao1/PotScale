import SwiftUI

struct RecipePickerView: View {
    @Binding var path: NavigationPath
    @State private var searchText = ""
    @State private var selectedCategory = "All"

    private var filtered: [Recipe] {
        let byCategory = selectedCategory == "All"
            ? MockData.recipes
            : MockData.recipes.filter { $0.category == selectedCategory }
        guard !searchText.isEmpty else { return byCategory }
        return byCategory.filter {
            $0.title.localizedCaseInsensitiveContains(searchText) ||
            $0.description.localizedCaseInsensitiveContains(searchText)
        }
    }

    var body: some View {
        ZStack {
            Theme.backgroundGradient.ignoresSafeArea()

            VStack(spacing: 0) {
                // Search bar
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(Theme.textSecondary)
                    TextField("Search recipes...", text: $searchText)
                        .font(AppFont.body())
                        .foregroundColor(Theme.textPrimary)
                        .tint(Theme.accent)
                        .autocorrectionDisabled()
                    if !searchText.isEmpty {
                        Button { searchText = "" } label: {
                            Image(systemName: "xmark.circle.fill")
                                .foregroundColor(Theme.textSecondary)
                        }
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 12)
                .background(Theme.surface)
                .clipShape(RoundedRectangle(cornerRadius: Theme.radiusM))
                .overlay(
                    RoundedRectangle(cornerRadius: Theme.radiusM)
                        .stroke(Theme.border, lineWidth: 1)
                )
                .padding(.horizontal, Theme.margin)
                .padding(.top, 8)
                .padding(.bottom, 14)

                // Category chips
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(MockData.categories) { cat in
                            CategoryChip(
                                label: cat.name,
                                icon: cat.icon,
                                isSelected: selectedCategory == cat.name
                            ) {
                                withAnimation(.spring(response: 0.3)) {
                                    selectedCategory = cat.name
                                }
                            }
                        }
                    }
                    .padding(.horizontal, Theme.margin)
                }
                .padding(.bottom, 16)

                // Results count
                HStack {
                    Text("\(filtered.count) recipe\(filtered.count == 1 ? "" : "s")")
                        .font(AppFont.caption())
                        .foregroundColor(Theme.textSecondary)
                    Spacer()
                }
                .padding(.horizontal, Theme.margin)
                .padding(.bottom, 8)

                // Recipe list
                ScrollView {
                    LazyVStack(spacing: 10) {
                        ForEach(filtered) { recipe in
                            RecipeCard(recipe: recipe) {
                                path.append(Route.recipeDetail(recipe))
                            }
                            .padding(.horizontal, Theme.margin)
                        }

                        if filtered.isEmpty {
                            EmptySearchState()
                                .padding(.top, 60)
                        }
                    }
                    .padding(.bottom, 32)
                }
            }
        }
        .navigationTitle("Recipes")
        .navigationBarTitleDisplayMode(.large)
    }
}

private struct EmptySearchState: View {
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 48, weight: .light))
                .foregroundColor(Theme.border)
            Text("No recipes found")
                .font(AppFont.subheading())
                .foregroundColor(Theme.textPrimary)
            Text("Try a different search or category.")
                .font(AppFont.body())
                .foregroundColor(Theme.textSecondary)
        }
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    NavigationStack {
        RecipePickerView(path: $path)
    }
    .preferredColorScheme(.dark)
}
