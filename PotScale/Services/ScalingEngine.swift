import Foundation

// MARK: - Warning

enum ScalingWarning: Equatable {
    case potTooSmall(minimum: Double)
    case scaleTooLarge(factor: Double)
}

// MARK: - Engine result

struct ScalingEngineResult {
    let factor: Double
    let scaledIngredients: [(original: Ingredient, scaled: Ingredient)]
    let warnings: [ScalingWarning]
}

// MARK: - Engine

enum ScalingEngine {
    static let minimumPotQuarts: Double = 0.5
    static let warningScaleFactor: Double = 5.0

    static func scale(recipe: Recipe, detectedQuarts: Double) -> ScalingEngineResult {
        let factor = detectedQuarts / recipe.suggestedPotQuarts
        var warnings: [ScalingWarning] = []

        if detectedQuarts < minimumPotQuarts {
            warnings.append(.potTooSmall(minimum: minimumPotQuarts))
        }
        if factor > warningScaleFactor {
            warnings.append(.scaleTooLarge(factor: factor))
        }

        let pairs: [(original: Ingredient, scaled: Ingredient)] = recipe.ingredients.map { ing in
            let rawQty = ing.quantity * factor
            let (normalizedQty, normalizedUnit) = UnitNormalizer.normalize(quantity: rawQty, unit: ing.unit)
            let scaledIng = Ingredient(id: ing.id, name: ing.name, quantity: normalizedQty, unit: normalizedUnit)
            return (original: ing, scaled: scaledIng)
        }

        return ScalingEngineResult(factor: factor, scaledIngredients: pairs, warnings: warnings)
    }
}

// MARK: - Unit normalizer

enum UnitNormalizer {
    private struct VolumeStep {
        let unit: String
        let inTsp: Double
    }

    private struct WeightStep {
        let unit: String
        let inOz: Double
    }

    // Ordered largest → smallest so we pick the biggest readable unit first
    private static let volumeSteps: [VolumeStep] = [
        VolumeStep(unit: "qt",   inTsp: 192),
        VolumeStep(unit: "cup",  inTsp: 48),
        VolumeStep(unit: "tbsp", inTsp: 3),
        VolumeStep(unit: "tsp",  inTsp: 1),
    ]

    private static let weightSteps: [WeightStep] = [
        WeightStep(unit: "lbs", inOz: 16),
        WeightStep(unit: "oz",  inOz: 1),
    ]

    // Aliases that map to canonical keys
    private static let volumeAliases: [String: String] = [
        "tsp": "tsp", "teaspoon": "tsp", "teaspoons": "tsp",
        "tbsp": "tbsp", "tablespoon": "tbsp", "tablespoons": "tbsp",
        "cup": "cup", "cups": "cup",
        "qt": "qt", "quart": "qt", "quarts": "qt",
        "pt": "cup",  // 1 pint = 2 cups; convert into cup space
        "pint": "cup", "pints": "cup",
        "fl oz": "tbsp",  // 1 fl oz ≈ 2 tbsp
    ]

    private static let weightAliases: [String: String] = [
        "oz": "oz", "ounce": "oz", "ounces": "oz",
        "lbs": "lbs", "lb": "lbs", "pound": "lbs", "pounds": "lbs",
    ]

    // pt = 2 cups; pint entry maps to "cup" but with 2× scaling
    // fl oz = 2 tbsp; maps to "tbsp" with 2× scaling
    private static let aliasMultiplier: [String: Double] = [
        "pt": 2, "pint": 2, "pints": 2,
        "fl oz": 2,
    ]

    static func normalize(quantity: Double, unit: String) -> (Double, String) {
        let key = unit.lowercased().trimmingCharacters(in: .whitespaces)
        let multiplier = aliasMultiplier[key] ?? 1.0

        // Volume path
        if let canonical = volumeAliases[key],
           let sourceStep = volumeSteps.first(where: { $0.unit == canonical }) {
            let totalTsp = quantity * multiplier * sourceStep.inTsp
            for step in volumeSteps {
                let inThisUnit = totalTsp / step.inTsp
                if inThisUnit >= 0.5 {
                    return (roundToEighth(inThisUnit), step.unit)
                }
            }
            return (roundToEighth(totalTsp), "tsp")
        }

        // Weight path
        if let canonical = weightAliases[key],
           let sourceStep = weightSteps.first(where: { $0.unit == canonical }) {
            let totalOz = quantity * sourceStep.inOz
            for step in weightSteps {
                let inThisUnit = totalOz / step.inOz
                if inThisUnit >= 0.5 {
                    return (roundToEighth(inThisUnit), step.unit)
                }
            }
            return (roundToEighth(totalOz), "oz")
        }

        // Unknown unit — pass through, just round to cooking-friendly precision
        return (roundToEighth(quantity), unit)
    }

    // Round to nearest 1/8 — covers all standard cooking fractions (1/4, 1/3≈3/8, 1/2, 2/3≈5/8, 3/4)
    static func roundToEighth(_ value: Double) -> Double {
        (value * 8).rounded() / 8
    }
}
