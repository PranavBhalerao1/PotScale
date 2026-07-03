import Foundation

struct Category: Identifiable, Hashable {
    let id: UUID
    let name: String
    let icon: String

    init(id: UUID = UUID(), name: String, icon: String) {
        self.id = id
        self.name = name
        self.icon = icon
    }
}

struct Ingredient: Identifiable, Hashable {
    let id: UUID
    let name: String
    let quantity: Double
    let unit: String

    init(id: UUID = UUID(), name: String, quantity: Double, unit: String) {
        self.id = id
        self.name = name
        self.quantity = quantity
        self.unit = unit
    }

    var formattedQuantity: String {
        if quantity == quantity.rounded() {
            return String(Int(quantity))
        }
        return String(format: "%.1f", quantity)
    }
}

struct Recipe: Identifiable, Hashable {
    let id: UUID
    let title: String
    let description: String
    let category: String
    let servings: Int
    let timeMinutes: Int
    let suggestedPotQuarts: Double
    let ingredients: [Ingredient]
    let steps: [String]

    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        category: String,
        servings: Int,
        timeMinutes: Int,
        suggestedPotQuarts: Double,
        ingredients: [Ingredient],
        steps: [String]
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.servings = servings
        self.timeMinutes = timeMinutes
        self.suggestedPotQuarts = suggestedPotQuarts
        self.ingredients = ingredients
        self.steps = steps
    }

    var subtitle: String { "Serves \(servings) · \(timeMinutes) min" }
    var potBadge: String { "~\(suggestedPotQuarts.formatted(.number.precision(.fractionLength(0...1)))) qt pot" }
}

struct ScaledResult {
    let recipe: Recipe
    let detectedQuarts: Double

    var scaleFactor: Double { detectedQuarts / recipe.suggestedPotQuarts }

    var scaledIngredients: [(original: Ingredient, scaled: Ingredient)] {
        recipe.ingredients.map { ing in
            let scaledQty = ing.quantity * scaleFactor
            let scaledIng = Ingredient(id: ing.id, name: ing.name, quantity: scaledQty, unit: ing.unit)
            return (original: ing, scaled: scaledIng)
        }
    }
}
