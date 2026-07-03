# PotScale — Project Context

## What this app does
PotScale scans a cooking pot/container and scales any recipe's ingredients
to match its exact size. Users pick a recipe first, then scan or manually
enter their pot size, and get exact scaled measurements.

## Current phase
UI-ONLY phase. Do NOT implement real logic, APIs, ARKit, or data persistence
yet. All data should be hardcoded/mocked. Focus entirely on visual polish,
layout, animations, and navigation flow.

## Tech stack
- Swift + SwiftUI (iOS only, target iOS 17+)
- MVVM structure: Views/, ViewModels/, Models/, Mock/
- No external packages needed for this phase

## Screens needed (in this order)
1. Home/Dashboard
2. Recipe Picker (browse + search, mock data)
3. Recipe Detail
4. Scan Pot (camera UI mockup, no real ARKit yet)
5. Result screen (scaled ingredients)
6. My Recipes (list + empty state)
7. Add Recipe (manual entry form + camera scan entry point, both UI only)

## Conventions
- Use SF Symbols for icons
- Prefer SwiftUI native components over custom-built ones unless design.md
  specifies otherwise
- Keep each screen in its own file under Views/
- Use @Previewable or #Preview for every screen so I can view them individually

## Screen-by-screen content

### 1. Home/Dashboard
- Large greeting/header ("PotScale" logo/wordmark top-left)
- One large primary CTA card/button: "Choose a Recipe" (leads to Recipe Picker)
- Secondary row of 2 smaller cards: "My Recipes" and "Recent Scans"
- No bottom tab bar needed yet — keep navigation simple (can revisit)

### 2. Recipe Picker
- Search bar at top
- Horizontal scrollable category chips (Breakfast, Dinner, Baking, etc.)
- Vertical scrollable list/grid of recipe cards (image placeholder, title,
  short subtitle like "Serves 4 · 30 min")
- Tapping a card goes to Recipe Detail

### 3. Recipe Detail
- Hero image placeholder at top
- Recipe title, short description
- "Suggested pot size" hint badge (e.g. "~3 qt pot")
- Ingredient list (name + base quantity)
- Instructions list (numbered steps)
- Sticky bottom CTA button: "Scan My Pot"

### 4. Scan Pot
- Full-screen camera view mockup (placeholder camera feed or dark overlay)
- Center framing guide (square/circle outline) with instruction text like
  "Center your pot in the frame"
- Bottom button: "Scan" (triggers fake 2-sec loading state, then shows
  "Detected: 3.2 qt" result card with Confirm/Retry buttons)
- Small text link below: "Enter size manually instead"

### 5. Result Screen
- Header showing detected pot size
- Two-column comparison: "Original recipe" vs "Scaled for your pot"
- Ingredient rows with quantities side by side
- Bottom button: "Save to My Recipes" (UI only, no real save)

### 6. My Recipes
- If empty: centered empty state illustration + text + "Add Recipe" button
- If populated: list of recipe cards similar to Recipe Picker but user-added
- Floating action button (+) to add new recipe

### 7. Add Recipe
- Two tab/segment options at top: "Manual Entry" and "Scan Recipe"
- Manual Entry: form fields for name, ingredients (repeatable rows: name,
  qty, unit), instructions (multi-line text)
- Scan Recipe: camera button + placeholder text explaining what happens
  ("We'll scan and extract your recipe a