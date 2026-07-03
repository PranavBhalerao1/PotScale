import SwiftUI

struct AddRecipeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var selectedTab = 0

    var body: some View {
        ZStack {
            Theme.backgroundGradient.ignoresSafeArea()

            VStack(spacing: 0) {
                // Segmented tabs
                Picker("Mode", selection: $selectedTab) {
                    Text("Manual Entry").tag(0)
                    Text("Scan Recipe").tag(1)
                }
                .pickerStyle(.segmented)
                .padding(.horizontal, Theme.margin)
                .padding(.vertical, 12)
                .background(Theme.background)

                if selectedTab == 0 {
                    ManualEntryForm()
                } else {
                    ScanRecipeTab()
                }
            }
        }
        .navigationTitle("Add Recipe")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Cancel") { dismiss() }
                    .foregroundColor(Theme.accent)
            }
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") { dismiss() }
                    .font(AppFont.label(15))
                    .foregroundColor(Theme.accent)
            }
        }
    }
}

// MARK: - Manual Entry Form
private struct ManualEntryForm: View {
    @State private var recipeName = ""
    @State private var description = ""
    @State private var potSize = ""
    @State private var ingredients: [IngredientEntry] = [IngredientEntry()]
    @State private var instructions = ""

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Basic info
                FormSection(title: "Basic Info") {
                    VStack(spacing: 0) {
                        FormTextField(
                            placeholder: "Recipe name",
                            text: $recipeName,
                            isLast: false
                        )
                        Divider().background(Theme.border).padding(.horizontal, Theme.gapL)
                        FormTextField(
                            placeholder: "Short description",
                            text: $description,
                            isLast: false
                        )
                        Divider().background(Theme.border).padding(.horizontal, Theme.gapL)
                        FormTextField(
                            placeholder: "Suggested pot size (e.g. 3 qt)",
                            text: $potSize,
                            isLast: true
                        )
                    }
                    .background(Theme.surface)
                    .clipShape(RoundedRectangle(cornerRadius: Theme.radiusM))
                    .overlay(
                        RoundedRectangle(cornerRadius: Theme.radiusM)
                            .stroke(Theme.border, lineWidth: 1)
                    )
                }

                // Ingredients
                FormSection(title: "Ingredients") {
                    VStack(spacing: 10) {
                        ForEach($ingredients) { $entry in
                            IngredientEntryRow(entry: $entry)
                        }

                        Button {
                            withAnimation(.spring(response: 0.3)) {
                                ingredients.append(IngredientEntry())
                            }
                        } label: {
                            HStack(spacing: 6) {
                                Image(systemName: "plus.circle.fill")
                                    .foregroundColor(Theme.accent)
                                Text("Add Ingredient")
                                    .font(AppFont.label(14))
                                    .foregroundColor(Theme.accent)
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 12)
                            .background(Theme.accentDim)
                            .clipShape(RoundedRectangle(cornerRadius: Theme.radiusM))
                        }
                        .buttonStyle(.plain)
                    }
                }

                // Instructions
                FormSection(title: "Instructions") {
                    TextEditor(text: $instructions)
                        .font(AppFont.body())
                        .foregroundColor(Theme.textPrimary)
                        .tint(Theme.accent)
                        .frame(minHeight: 140)
                        .scrollContentBackground(.hidden)
                        .padding(Theme.gapL)
                        .background(Theme.surface)
                        .clipShape(RoundedRectangle(cornerRadius: Theme.radiusM))
                        .overlay(
                            RoundedRectangle(cornerRadius: Theme.radiusM)
                                .stroke(Theme.border, lineWidth: 1)
                        )
                        .overlay(alignment: .topLeading) {
                            if instructions.isEmpty {
                                Text("Write your steps here…")
                                    .font(AppFont.body())
                                    .foregroundColor(Theme.textSecondary.opacity(0.5))
                                    .padding(.horizontal, Theme.gapL + 4)
                                    .padding(.top, Theme.gapL + 8)
                                    .allowsHitTesting(false)
                            }
                        }
                }

                Spacer(minLength: 40)
            }
            .padding(.horizontal, Theme.margin)
            .padding(.top, 16)
            .padding(.bottom, 40)
        }
    }
}

private struct FormSection<Content: View>: View {
    let title: String
    let content: Content

    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(AppFont.label(14))
                .foregroundColor(Theme.textSecondary)
            content
        }
    }
}

private struct FormTextField: View {
    let placeholder: String
    @Binding var text: String
    let isLast: Bool

    var body: some View {
        TextField(placeholder, text: $text)
            .font(AppFont.body())
            .foregroundColor(Theme.textPrimary)
            .tint(Theme.accent)
            .padding(.horizontal, Theme.gapL)
            .padding(.vertical, 14)
    }
}

struct IngredientEntry: Identifiable {
    let id = UUID()
    var name = ""
    var quantity = ""
    var unit = ""
}

private struct IngredientEntryRow: View {
    @Binding var entry: IngredientEntry

    var body: some View {
        HStack(spacing: 8) {
            TextField("Ingredient", text: $entry.name)
                .font(AppFont.body(14))
                .foregroundColor(Theme.textPrimary)
                .tint(Theme.accent)

            TextField("Qty", text: $entry.quantity)
                .font(AppFont.body(14))
                .foregroundColor(Theme.textPrimary)
                .tint(Theme.accent)
                .keyboardType(.decimalPad)
                .frame(width: 52)

            TextField("Unit", text: $entry.unit)
                .font(AppFont.body(14))
                .foregroundColor(Theme.textPrimary)
                .tint(Theme.accent)
                .frame(width: 56)
        }
        .padding(.horizontal, Theme.gapL)
        .padding(.vertical, 12)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: Theme.radiusM))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.radiusM)
                .stroke(Theme.border, lineWidth: 1)
        )
    }
}

// MARK: - Scan Recipe Tab
private struct ScanRecipeTab: View {
    @State private var tapped = false

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                Spacer(minLength: 40)

                // Camera button
                Button {
                    withAnimation(.spring(response: 0.3)) { tapped.toggle() }
                } label: {
                    ZStack {
                        Circle()
                            .fill(tapped ? Theme.accentGradient : AnyShapeStyle(Theme.surface))
                            .frame(width: 120, height: 120)
                            .overlay(
                                Circle().stroke(Theme.border, lineWidth: 1)
                            )
                            .shadow(color: tapped ? Theme.accent.opacity(0.4) : .clear, radius: 20)

                        Image(systemName: "camera.fill")
                            .font(.system(size: 44, weight: .light))
                            .foregroundColor(tapped ? .white : Theme.textSecondary)
                    }
                }
                .buttonStyle(.plain)

                VStack(spacing: 12) {
                    Text("Scan a Recipe Card")
                        .font(AppFont.heading(22))
                        .foregroundColor(Theme.textPrimary)

                    Text("Point your camera at a printed recipe or\nopen a photo from your library. PotScale\nwill extract the ingredients and steps\nautomatically.")
                        .font(AppFont.body())
                        .foregroundColor(Theme.textSecondary)
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                }

                // Feature pills
                VStack(spacing: 8) {
                    FeaturePill(icon: "doc.text.viewfinder", text: "Extracts ingredients & quantities")
                    FeaturePill(icon: "checkmark.seal.fill", text: "Detects serving size automatically")
                    FeaturePill(icon: "pencil.and.list.clipboard", text: "Editable before saving")
                }

                Spacer(minLength: 40)
            }
            .padding(.horizontal, Theme.margin)
        }
    }
}

private struct FeaturePill: View {
    let icon: String
    let text: String

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .font(.system(size: 14, weight: .semibold))
                .foregroundColor(Theme.accent)
                .frame(width: 20)
            Text(text)
                .font(AppFont.body(15))
                .foregroundColor(Theme.textSecondary)
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Theme.surface)
        .clipShape(RoundedRectangle(cornerRadius: Theme.radiusM))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.radiusM)
                .stroke(Theme.border, lineWidth: 1)
        )
    }
}

#Preview("Manual") {
    NavigationStack {
        AddRecipeView()
    }
    .preferredColorScheme(.dark)
}

#Preview("Scan Tab") {
    NavigationStack {
        AddRecipeView()
    }
    .preferredColorScheme(.dark)
}
