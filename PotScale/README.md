# PotScale — How to Open in Xcode

## Step 1 — Create the Xcode project

1. Open Xcode → **File → New → Project**
2. Choose **iOS → App**, click **Next**
3. Fill in:
   - **Product Name**: `PotScale`
   - **Interface**: SwiftUI
   - **Language**: Swift
   - **Minimum Deployments**: iOS 17.0
4. Save the project **in this folder** (so `PotScale.xcodeproj` sits next to this `README.md`)
5. Xcode creates a default `ContentView.swift` and `PotScaleApp.swift` — **delete both** (move to Trash).

## Step 2 — Add the source files

1. In the Xcode Project Navigator, right-click the **PotScale** group → **Add Files to "PotScale"…**
2. Navigate to this `PotScale/` folder and select these subfolders:
   - `DesignSystem/`
   - `Models/`
   - `Mock/`
   - `ViewModels/`
   - `Views/`
3. Also add `PotScaleApp.swift` from the root of `PotScale/`.
4. Make sure **"Copy items if needed"** is **unchecked** (files are already in place) and **"Add to target: PotScale"** is checked.

## Step 3 — Build & run

- Press **⌘R** to run in the Simulator (iPhone 15 recommended).
- Or open individual files and use **⌘⌥P** to preview each screen in Xcode Previews.

## Navigation map

```
Home
├── Choose a Recipe → Recipe Picker → Recipe Detail → Scan Pot → Result
├── My Recipes (empty state / populated toggle in toolbar)
│   └── + FAB → Add Recipe (Manual Entry / Scan tab)
└── Recent Scans → My Recipes
```

## Mock data notes

- 6 recipes across Breakfast, Dinner, Soup, Baking, Salads
- Scan screen fakes a 2-second scan and detects **3.2 qt**
- Result screen scales all quantities by `detectedQuarts / suggestedPotQuarts`
- "Save to My Recipes" is UI-only — toggles a confirmation state, no persistence
- My Recipes has a toolbar toggle to preview both empty state and populated list
