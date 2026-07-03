import Foundation

enum MockData {
    static let categories: [Category] = [
        Category(name: "All", icon: "🍽️"),
        Category(name: "Breakfast", icon: "🥞"),
        Category(name: "Dinner", icon: "🍝"),
        Category(name: "Soup", icon: "🍲"),
        Category(name: "Baking", icon: "🧁"),
        Category(name: "Salads", icon: "🥗"),
    ]

    static let recipes: [Recipe] = [
        Recipe(
            title: "Classic Tomato Soup",
            description: "A rich, velvety tomato soup with fresh basil and a touch of cream. Perfect for a cozy evening.",
            category: "Soup",
            servings: 4,
            timeMinutes: 35,
            suggestedPotQuarts: 3.0,
            ingredients: [
                Ingredient(name: "Crushed tomatoes", quantity: 28, unit: "oz"),
                Ingredient(name: "Vegetable broth", quantity: 2, unit: "cups"),
                Ingredient(name: "Heavy cream", quantity: 0.5, unit: "cups"),
                Ingredient(name: "Onion, diced", quantity: 1, unit: "medium"),
                Ingredient(name: "Garlic cloves", quantity: 3, unit: "cloves"),
                Ingredient(name: "Olive oil", quantity: 2, unit: "tbsp"),
                Ingredient(name: "Fresh basil", quantity: 0.25, unit: "cup"),
            ],
            steps: [
                "Heat olive oil in a large pot over medium heat.",
                "Sauté onion until translucent, about 5 minutes. Add garlic and cook 1 minute more.",
                "Pour in crushed tomatoes and vegetable broth. Bring to a simmer.",
                "Cook uncovered for 20 minutes, stirring occasionally.",
                "Blend until smooth using an immersion blender.",
                "Stir in heavy cream and fresh basil. Season with salt and pepper. Serve hot.",
            ]
        ),
        Recipe(
            title: "Spaghetti Bolognese",
            description: "A hearty Italian meat sauce slow-cooked to perfection, served over al dente pasta.",
            category: "Dinner",
            servings: 6,
            timeMinutes: 90,
            suggestedPotQuarts: 4.0,
            ingredients: [
                Ingredient(name: "Ground beef", quantity: 1.5, unit: "lbs"),
                Ingredient(name: "Spaghetti", quantity: 1, unit: "lb"),
                Ingredient(name: "Crushed tomatoes", quantity: 28, unit: "oz"),
                Ingredient(name: "Tomato paste", quantity: 2, unit: "tbsp"),
                Ingredient(name: "Red wine", quantity: 0.5, unit: "cup"),
                Ingredient(name: "Onion, diced", quantity: 1, unit: "large"),
                Ingredient(name: "Carrots, diced", quantity: 2, unit: "medium"),
                Ingredient(name: "Celery stalks", quantity: 2, unit: "stalks"),
                Ingredient(name: "Parmesan cheese", quantity: 0.5, unit: "cup"),
            ],
            steps: [
                "Sauté onion, carrot, and celery in olive oil until softened.",
                "Add ground beef and cook until browned, breaking up with a spoon.",
                "Pour in wine and let it reduce for 2 minutes.",
                "Stir in tomato paste, then crushed tomatoes. Season generously.",
                "Simmer on low heat for 45–60 minutes, stirring occasionally.",
                "Cook spaghetti according to package directions. Serve sauce over pasta with Parmesan.",
            ]
        ),
        Recipe(
            title: "Fluffy Pancakes",
            description: "Light, airy pancakes with a golden crust. Serve with maple syrup and fresh berries.",
            category: "Breakfast",
            servings: 4,
            timeMinutes: 25,
            suggestedPotQuarts: 1.5,
            ingredients: [
                Ingredient(name: "All-purpose flour", quantity: 2, unit: "cups"),
                Ingredient(name: "Milk", quantity: 1.5, unit: "cups"),
                Ingredient(name: "Eggs", quantity: 2, unit: "large"),
                Ingredient(name: "Butter, melted", quantity: 3, unit: "tbsp"),
                Ingredient(name: "Baking powder", quantity: 2, unit: "tsp"),
                Ingredient(name: "Sugar", quantity: 2, unit: "tbsp"),
                Ingredient(name: "Salt", quantity: 0.5, unit: "tsp"),
            ],
            steps: [
                "Whisk together flour, baking powder, sugar, and salt in a large bowl.",
                "In a separate bowl, whisk milk, eggs, and melted butter.",
                "Pour wet ingredients into dry and stir until just combined — lumps are okay.",
                "Let batter rest 5 minutes.",
                "Pour ¼ cup batter onto a lightly greased griddle over medium heat.",
                "Cook until bubbles form on surface, then flip. Cook 1–2 minutes more.",
            ]
        ),
        Recipe(
            title: "Chicken Noodle Soup",
            description: "Classic comfort soup with tender chicken, hearty vegetables, and egg noodles.",
            category: "Soup",
            servings: 6,
            timeMinutes: 60,
            suggestedPotQuarts: 5.0,
            ingredients: [
                Ingredient(name: "Chicken thighs, bone-in", quantity: 2, unit: "lbs"),
                Ingredient(name: "Egg noodles", quantity: 2, unit: "cups"),
                Ingredient(name: "Chicken broth", quantity: 6, unit: "cups"),
                Ingredient(name: "Carrots, sliced", quantity: 3, unit: "medium"),
                Ingredient(name: "Celery stalks", quantity: 3, unit: "stalks"),
                Ingredient(name: "Onion, diced", quantity: 1, unit: "large"),
                Ingredient(name: "Fresh thyme", quantity: 4, unit: "sprigs"),
                Ingredient(name: "Bay leaves", quantity: 2, unit: "leaves"),
            ],
            steps: [
                "Place chicken, broth, thyme, and bay leaves in a large pot. Bring to a boil.",
                "Reduce heat and simmer 25 minutes until chicken is cooked through.",
                "Remove chicken, shred meat, and discard bones and skin.",
                "Add carrots, celery, and onion to the broth. Simmer 10 minutes.",
                "Add egg noodles and cook until tender, about 8 minutes.",
                "Return shredded chicken to pot. Season with salt and pepper. Remove bay leaves.",
            ]
        ),
        Recipe(
            title: "Banana Bread",
            description: "Moist, dense banana bread with a crackly sugar top. Best made with very ripe bananas.",
            category: "Baking",
            servings: 8,
            timeMinutes: 70,
            suggestedPotQuarts: 2.0,
            ingredients: [
                Ingredient(name: "Ripe bananas", quantity: 3, unit: "large"),
                Ingredient(name: "All-purpose flour", quantity: 1.5, unit: "cups"),
                Ingredient(name: "Sugar", quantity: 0.75, unit: "cup"),
                Ingredient(name: "Butter, melted", quantity: 0.33, unit: "cup"),
                Ingredient(name: "Egg", quantity: 1, unit: "large"),
                Ingredient(name: "Baking soda", quantity: 1, unit: "tsp"),
                Ingredient(name: "Vanilla extract", quantity: 1, unit: "tsp"),
            ],
            steps: [
                "Preheat oven to 350°F (175°C). Grease a 9×5 loaf pan.",
                "Mash bananas in a large bowl until smooth.",
                "Stir in melted butter, then mix in sugar, egg, and vanilla.",
                "Sprinkle baking soda and a pinch of salt over the mixture and stir in.",
                "Fold in flour until just combined.",
                "Pour into prepared pan. Bake 55–65 minutes until a toothpick comes out clean.",
            ]
        ),
        Recipe(
            title: "Greek Salad",
            description: "Crisp vegetables, briny olives, and creamy feta tossed in a zesty oregano dressing.",
            category: "Salads",
            servings: 4,
            timeMinutes: 15,
            suggestedPotQuarts: 1.0,
            ingredients: [
                Ingredient(name: "Cucumber, chopped", quantity: 1, unit: "large"),
                Ingredient(name: "Cherry tomatoes", quantity: 1.5, unit: "cups"),
                Ingredient(name: "Kalamata olives", quantity: 0.5, unit: "cup"),
                Ingredient(name: "Feta cheese, crumbled", quantity: 0.5, unit: "cup"),
                Ingredient(name: "Red onion, sliced", quantity: 0.25, unit: "medium"),
                Ingredient(name: "Olive oil", quantity: 3, unit: "tbsp"),
                Ingredient(name: "Red wine vinegar", quantity: 1, unit: "tbsp"),
                Ingredient(name: "Dried oregano", quantity: 1, unit: "tsp"),
            ],
            steps: [
                "Combine cucumber, tomatoes, olives, and red onion in a large bowl.",
                "Whisk together olive oil, vinegar, and oregano. Season with salt and pepper.",
                "Pour dressing over vegetables and toss gently.",
                "Top with crumbled feta. Serve immediately or refrigerate up to 2 hours.",
            ]
        ),
    ]

    static let detectedPotSizes: [Double] = [1.5, 2.0, 3.2, 4.0, 5.5, 6.0]

    static var defaultDetected: Double { 3.2 }
}
