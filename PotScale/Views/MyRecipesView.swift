import SwiftUI

struct MyRecipesView: View {
    @Binding var path: NavigationPath

    // For the mock, show empty state by default (user hasn't saved anything)
    @State private var showPopulated = false
    @State private var showAdd = false

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            Theme.backgroundGradient.ignoresSafeArea()

            if showPopulated {
                PopulatedList(path: $path)
            } else {
                EmptyStateView {
                    showAdd = true
                }
            }

            // FAB
            FABButton {
                showAdd = true
            }
            .padding(.trailing, Theme.margin)
            .padding(.bottom, 32)
        }
        .navigationTitle("My Recipes")
        .navigationBarTitleDisplayMode(.large)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button(showPopulated ? "Show Empty" : "Show Filled") {
                    withAnimation(.spring(response: 0.4)) { showPopulated.toggle() }
                }
                .font(AppFont.caption(13, weight: .semibold))
                .foregroundColor(Theme.accent)
            }
        }
        .sheet(isPresented: $showAdd) {
            NavigationStack {
                AddRecipeView()
            }
        }
    }
}

private struct EmptyStateView: View {
    let onAdd: () -> Void

    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            ZStack {
                Circle()
                    .fill(Theme.accentDim)
                    .frame(width: 100, height: 100)
                Image(systemName: "fork.knife")
                    .font(.system(size: 44, weight: .light))
                    .foregroundColor(Theme.accent)
            }

            VStack(spacing: 8) {
                Text("No recipes yet")
                    .font(AppFont.heading(24))
                    .foregroundColor(Theme.textPrimary)
                Text("Save a scaled recipe or add your own\nto see them here.")
                    .font(AppFont.body())
                    .foregroundColor(Theme.textSecondary)
                    .multilineTextAlignment(.center)
            }

            Button(action: onAdd) {
                Label("Add Recipe", systemImage: "plus")
                    .font(AppFont.label(15))
                    .foregroundColor(.white)
                    .padding(.horizontal, 28)
                    .padding(.vertical, 14)
                    .background(Theme.accentGradient)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radiusFull))
            }
            .buttonStyle(.plain)

            Spacer()
        }
        .padding(.horizontal, Theme.margin)
    }
}

private struct PopulatedList: View {
    @Binding var path: NavigationPath

    // Show a few mock "saved" recipes
    private let saved = Array(MockData.recipes.prefix(3))

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 10) {
                ForEach(saved) { recipe in
                    RecipeCard(recipe: recipe) {
                        path.append(Route.recipeDetail(recipe))
                    }
                    .padding(.horizontal, Theme.margin)
                }
            }
            .padding(.top, 16)
            .padding(.bottom, 100)
        }
    }
}

#Preview("Empty") {
    @Previewable @State var path = NavigationPath()
    NavigationStack {
        MyRecipesView(path: $path)
    }
    .preferredColorScheme(.dark)
}
