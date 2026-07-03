import XCTest
@testable import PotScale

final class ScalingEngineTests: XCTestCase {

    // MARK: - Helpers

    private func makeRecipe(
        suggestedQuarts: Double,
        ingredients: [Ingredient] = []
    ) -> Recipe {
        Recipe(
            title: "Test Recipe",
            description: "",
            category: "Test",
            servings: 4,
            timeMinutes: 30,
            suggestedPotQuarts: suggestedQuarts,
            ingredients: ingredients,
            steps: []
        )
    }

    private func makeIngredient(
        name: String = "Ingredient",
        quantity: Double,
        unit: String
    ) -> Ingredient {
        Ingredient(name: name, quantity: quantity, unit: unit)
    }

    // MARK: - Scale factor tests

    func testScaleUp() {
        let recipe = makeRecipe(
            suggestedQuarts: 2.0,
            ingredients: [makeIngredient(quantity: 1.0, unit: "cup")]
        )
        let result = ScalingEngine.scale(recipe: recipe, detectedQuarts: 4.0)

        XCTAssertEqual(result.factor, 2.0, accuracy: 0.001)
        XCTAssertTrue(result.warnings.isEmpty)
        // 1 cup × 2 = 2 cups
        XCTAssertEqual(result.scaledIngredients[0].scaled.quantity, 2.0, accuracy: 0.001)
        XCTAssertEqual(result.scaledIngredients[0].scaled.unit, "cup")
    }

    func testScaleDown() {
        let recipe = makeRecipe(
            suggestedQuarts: 3.0,
            ingredients: [makeIngredient(quantity: 2.0, unit: "cup")]
        )
        let result = ScalingEngine.scale(recipe: recipe, detectedQuarts: 1.5)

        XCTAssertEqual(result.factor, 0.5, accuracy: 0.001)
        XCTAssertTrue(result.warnings.isEmpty)
        // 2 cups × 0.5 = 1 cup
        XCTAssertEqual(result.scaledIngredients[0].scaled.quantity, 1.0, accuracy: 0.001)
        XCTAssertEqual(result.scaledIngredients[0].scaled.unit, "cup")
    }

    func testExactMatch() {
        let recipe = makeRecipe(
            suggestedQuarts: 3.0,
            ingredients: [
                makeIngredient(quantity: 2.0, unit: "cup"),
                makeIngredient(quantity: 1.0, unit: "tbsp"),
            ]
        )
        let result = ScalingEngine.scale(recipe: recipe, detectedQuarts: 3.0)

        XCTAssertEqual(result.factor, 1.0, accuracy: 0.001)
        XCTAssertTrue(result.warnings.isEmpty)
        XCTAssertEqual(result.scaledIngredients[0].scaled.quantity, 2.0, accuracy: 0.001)
        XCTAssertEqual(result.scaledIngredients[1].scaled.quantity, 1.0, accuracy: 0.001)
    }

    // MARK: - Warning tests

    func testPotTooSmallWarning() {
        let recipe = makeRecipe(suggestedQuarts: 3.0)
        let result = ScalingEngine.scale(recipe: recipe, detectedQuarts: 0.25)

        XCTAssertTrue(result.warnings.contains(.potTooSmall(minimum: ScalingEngine.minimumPotQuarts)))
    }

    func testPotTooSmallNotTriggeredAtBoundary() {
        let recipe = makeRecipe(suggestedQuarts: 3.0)
        let result = ScalingEngine.scale(recipe: recipe, detectedQuarts: 0.5)

        XCTAssertFalse(result.warnings.contains { if case .potTooSmall = $0 { return true }; return false })
    }

    func testScaleTooLargeWarning() {
        let recipe = makeRecipe(suggestedQuarts: 1.0)
        let result = ScalingEngine.scale(recipe: recipe, detectedQuarts: 6.0)

        XCTAssertTrue(result.warnings.contains(.scaleTooLarge(factor: 6.0)))
    }

    func testScaleTooLargeNotTriggeredAtBoundary() {
        let recipe = makeRecipe(suggestedQuarts: 1.0)
        let result = ScalingEngine.scale(recipe: recipe, detectedQuarts: 5.0)

        XCTAssertFalse(result.warnings.contains { if case .scaleTooLarge = $0 { return true }; return false })
    }

    func testBothWarningsCanOccurTogether() {
        // 0.25 qt is too small AND if base recipe is also tiny, factor could be > 5
        let recipe = makeRecipe(suggestedQuarts: 0.04)
        let result = ScalingEngine.scale(recipe: recipe, detectedQuarts: 0.25)

        XCTAssertTrue(result.warnings.contains { if case .potTooSmall = $0 { return true }; return false })
        XCTAssertTrue(result.warnings.contains { if case .scaleTooLarge = $0 { return true }; return false })
    }

    // MARK: - Unit normalization tests

    func testTspToTbspNormalization() {
        // 3 tsp × 1.0 = 3 tsp → should normalize to 1 tbsp
        let recipe = makeRecipe(
            suggestedQuarts: 1.0,
            ingredients: [makeIngredient(quantity: 3.0, unit: "tsp")]
        )
        let result = ScalingEngine.scale(recipe: recipe, detectedQuarts: 1.0)

        XCTAssertEqual(result.scaledIngredients[0].scaled.unit, "tbsp")
        XCTAssertEqual(result.scaledIngredients[0].scaled.quantity, 1.0, accuracy: 0.001)
    }

    func testTbspToCupNormalization() {
        // 16 tbsp × 1.0 = 16 tbsp → 1 cup
        let recipe = makeRecipe(
            suggestedQuarts: 1.0,
            ingredients: [makeIngredient(quantity: 16.0, unit: "tbsp")]
        )
        let result = ScalingEngine.scale(recipe: recipe, detectedQuarts: 1.0)

        XCTAssertEqual(result.scaledIngredients[0].scaled.unit, "cup")
        XCTAssertEqual(result.scaledIngredients[0].scaled.quantity, 1.0, accuracy: 0.001)
    }

    func testCupDownToTbsp() {
        // 0.25 cup × 0.5 = 0.125 cup = 6 tsp = 2 tbsp → should be 2 tbsp
        let recipe = makeRecipe(
            suggestedQuarts: 2.0,
            ingredients: [makeIngredient(quantity: 0.25, unit: "cup")]
        )
        let result = ScalingEngine.scale(recipe: recipe, detectedQuarts: 1.0)

        XCTAssertEqual(result.scaledIngredients[0].scaled.unit, "tbsp")
        XCTAssertEqual(result.scaledIngredients[0].scaled.quantity, 2.0, accuracy: 0.001)
    }

    func testOzToLbsNormalization() {
        // 32 oz × 1.0 = 32 oz → 2 lbs
        let recipe = makeRecipe(
            suggestedQuarts: 1.0,
            ingredients: [makeIngredient(quantity: 32.0, unit: "oz")]
        )
        let result = ScalingEngine.scale(recipe: recipe, detectedQuarts: 1.0)

        XCTAssertEqual(result.scaledIngredients[0].scaled.unit, "lbs")
        XCTAssertEqual(result.scaledIngredients[0].scaled.quantity, 2.0, accuracy: 0.001)
    }

    func testUnknownUnitPassthrough() {
        // "cloves" is not a known unit — quantity should scale, unit should stay
        let recipe = makeRecipe(
            suggestedQuarts: 2.0,
            ingredients: [makeIngredient(quantity: 4.0, unit: "cloves")]
        )
        let result = ScalingEngine.scale(recipe: recipe, detectedQuarts: 4.0)

        XCTAssertEqual(result.scaledIngredients[0].scaled.unit, "cloves")
        XCTAssertEqual(result.scaledIngredients[0].scaled.quantity, 8.0, accuracy: 0.001)
    }

    func testOriginalIngredientPreserved() {
        // The original ingredient must not be modified
        let ing = makeIngredient(quantity: 2.0, unit: "cup")
        let recipe = makeRecipe(suggestedQuarts: 1.0, ingredients: [ing])
        let result = ScalingEngine.scale(recipe: recipe, detectedQuarts: 2.0)

        XCTAssertEqual(result.scaledIngredients[0].original.quantity, 2.0)
        XCTAssertEqual(result.scaledIngredients[0].original.unit, "cup")
    }

    // MARK: - Rounding

    func testRoundToEighth() {
        XCTAssertEqual(UnitNormalizer.roundToEighth(0.33), 0.375, accuracy: 0.001) // 3/8
        XCTAssertEqual(UnitNormalizer.roundToEighth(0.66), 0.625, accuracy: 0.001) // 5/8
        XCTAssertEqual(UnitNormalizer.roundToEighth(1.0),  1.0,   accuracy: 0.001)
        XCTAssertEqual(UnitNormalizer.roundToEighth(2.5),  2.5,   accuracy: 0.001)
    }
}
