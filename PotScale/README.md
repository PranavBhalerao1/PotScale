## Step 1 — Create the Xcode project (in a temporary location)

1. Open Xcode → File → New → Project
2. Choose iOS → App, click Next
3. Fill in:
   - Product Name: PotScale
   - Interface: SwiftUI
   - Language: Swift
   - Minimum Deployments: iOS 17.0
4. IMPORTANT: Save this new project to your Desktop or a temp folder —
   NOT inside your existing PotScale repo folder. This avoids folder
   name collisions with your existing PotScale/PotScale/ structure.
5. Xcode creates PotScaleTemp/PotScaleTemp.xcodeproj plus default
   ContentView.swift and PotScaleTempApp.swift inside a
   PotScaleTemp/PotScaleTemp/ folder.

## Step 2 — Move the .xcodeproj into your real repo

1. Close Xcode.
2. Drag/move just the .xcodeproj file (e.g. PotScaleTemp.xcodeproj) into
   your repo root — the same level as claude.md and design.md, NOT inside
   the PotScale/ source folder.
3. Rename it to PotScale.xcodeproj.
4. Delete the leftover PotScaleTemp folder entirely — you don't need its
   default ContentView.swift or generated app file, since your repo
   already has a real PotScaleApp.swift.

## Step 3 — Open and wire up the project

1. Double-click PotScale.xcodeproj to open it in Xcode.
2. It will show as basically empty (just referencing files that don't
   exist at the paths it expects yet).
3. Right-click the project in the Navigator → Add Files to "PotScale"...
4. Select your existing PotScale/ folder (the one containing
   DesignSystem/, Models/, Mock/, Services/, ViewModels/, Views/,
   PotScaleApp.swift).
5. Make sure "Copy items if needed" is UNCHECKED and "Create groups"
   is selected (not folder references), "Add to target: PotScale" checked.

## Step 4 — Add the unit test target

1. File → New → Target… → Unit Testing Bundle
2. Product Name: PotScaleTests, linked to the PotScale project
3. Delete Xcode's default generated test file
4. Right-click PotScaleTests group → Add Files to "PotScaleTests"…
5. Select your existing PotScaleTests/ScalingEngineTests.swift
6. Press ⌘U to run tests — all should pass

## Step 5 — Build & run

- Press ⌘R to run in the Simulator (iPhone 15 recommended)
- Or use ⌘⌥P for Xcode Previews on individual screens