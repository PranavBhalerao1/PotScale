import SwiftUI

enum Route: Hashable {
    case recipePicker
    case recipeDetail(Recipe)
    case scanPot(Recipe)
    case result(ScaledResult)
    case myRecipes
    case addRecipe
}

extension ScaledResult: Hashable {
    static func == (lhs: ScaledResult, rhs: ScaledResult) -> Bool {
        lhs.recipe.id == rhs.recipe.id && lhs.detectedQuarts == rhs.detectedQuarts
    }
    func hash(into hasher: inout Hasher) {
        hasher.combine(recipe.id)
        hasher.combine(detectedQuarts)
    }
}

@main
struct PotScaleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentRoot()
                .preferredColorScheme(.dark)
        }
    }
}

struct ContentRoot: View {
    @State private var path = NavigationPath()

    var body: some View {
        NavigationStack(path: $path) {
            HomeView(path: $path)
                .navigationDestination(for: Route.self) { route in
                    switch route {
                    case .recipePicker:
                        RecipePickerView(path: $path)
                    case .recipeDetail(let recipe):
                        RecipeDetailView(recipe: recipe, path: $path)
                    case .scanPot(let recipe):
                        ScanPotView(recipe: recipe, path: $path)
                    case .result(let result):
                        ResultView(result: result, path: $path)
                    case .myRecipes:
                        MyRecipesView(path: $path)
                    case .addRecipe:
                        AddRecipeView()
                    }
                }
        }
        .tint(Theme.accent)
    }
}
