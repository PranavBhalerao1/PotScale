import SwiftUI

struct ScanPotView: View {
    let recipe: Recipe
    @Binding var path: NavigationPath
    @StateObject private var vm = ScanViewModel()
    @State private var showManualEntry = false

    var body: some View {
        ZStack {
            // Dark camera mockup background
            Color.black.ignoresSafeArea()

            // Subtle noise/vignette
            RadialGradient(
                colors: [Color.clear, Color.black.opacity(0.7)],
                center: .center,
                startRadius: 150,
                endRadius: 400
            )
            .ignoresSafeArea()

            VStack(spacing: 0) {
                // Top info bar
                VStack(spacing: 4) {
                    Text("Scan Your Pot")
                        .font(AppFont.subheading(18))
                        .foregroundColor(.white)
                    Text("Scanning for: \(recipe.title)")
                        .font(AppFont.caption())
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding(.top, 16)
                .padding(.bottom, 32)

                Spacer()

                // Framing guide
                ZStack {
                    // Corner markers
                    FramingGuide()

                    if vm.isScanning {
                        // Animated scanning line
                        ScanningAnimation()
                    }

                    if vm.detectedSize == nil && !vm.isScanning {
                        VStack(spacing: 8) {
                            Image(systemName: "camera.viewfinder")
                                .font(.system(size: 36, weight: .light))
                                .foregroundColor(.white.opacity(0.4))
                            Text("Center your pot in the frame")
                                .font(AppFont.body(15))
                                .foregroundColor(.white.opacity(0.7))
                                .multilineTextAlignment(.center)
                        }
                    }
                }
                .frame(width: 260, height: 260)

                Spacer()

                // Bottom panel
                VStack(spacing: 16) {
                    // Detected result card
                    if let size = vm.detectedSize {
                        DetectedResultCard(size: size) {
                            let result = ScaledResult(recipe: recipe, detectedQuarts: size)
                            path.append(Route.result(result))
                        } onRetry: {
                            vm.retry()
                        }
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                    } else {
                        // Scan button
                        PrimaryButton(
                            vm.isScanning ? "Scanning..." : "Scan",
                            icon: vm.isScanning ? nil : "camera.fill"
                        ) {
                            vm.startScan()
                        }
                        .disabled(vm.isScanning)
                        .opacity(vm.isScanning ? 0.6 : 1)
                        .padding(.horizontal, Theme.margin)

                        Button { showManualEntry = true } label: {
                            Text("Enter size manually instead")
                                .font(AppFont.caption(14))
                                .foregroundColor(.white.opacity(0.5))
                                .underline()
                        }
                    }
                }
                .padding(.horizontal, vm.detectedSize != nil ? Theme.margin : 0)
                .padding(.bottom, 48)
                .animation(.spring(response: 0.4, dampingFraction: 0.75), value: vm.detectedSize != nil)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .preferredColorScheme(.dark)
        .sheet(isPresented: $showManualEntry) {
            ManualSizeSheet(recipe: recipe, path: $path)
        }
    }
}

// MARK: - Framing Guide
private struct FramingGuide: View {
    let cornerLength: CGFloat = 28
    let lineWidth: CGFloat = 3

    var body: some View {
        ZStack {
            // Dashed border
            RoundedRectangle(cornerRadius: 20)
                .stroke(Color.white.opacity(0.15), style: StrokeStyle(lineWidth: 1, dash: [6, 4]))

            // Corner accents
            GeometryReader { geo in
                let w = geo.size.width
                let h = geo.size.height
                let r: CGFloat = 20

                Group {
                    // Top-left
                    Path { p in
                        p.move(to: CGPoint(x: 0, y: r + cornerLength))
                        p.addLine(to: CGPoint(x: 0, y: r))
                        p.addArc(center: CGPoint(x: r, y: r), radius: r, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false)
                        p.addLine(to: CGPoint(x: r + cornerLength, y: 0))
                    }
                    // Top-right
                    Path { p in
                        p.move(to: CGPoint(x: w - r - cornerLength, y: 0))
                        p.addLine(to: CGPoint(x: w - r, y: 0))
                        p.addArc(center: CGPoint(x: w - r, y: r), radius: r, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false)
                        p.addLine(to: CGPoint(x: w, y: r + cornerLength))
                    }
                    // Bottom-left
                    Path { p in
                        p.move(to: CGPoint(x: 0, y: h - r - cornerLength))
                        p.addLine(to: CGPoint(x: 0, y: h - r))
                        p.addArc(center: CGPoint(x: r, y: h - r), radius: r, startAngle: .degrees(180), endAngle: .degrees(90), clockwise: true)
                        p.addLine(to: CGPoint(x: r + cornerLength, y: h))
                    }
                    // Bottom-right
                    Path { p in
                        p.move(to: CGPoint(x: w - r - cornerLength, y: h))
                        p.addLine(to: CGPoint(x: w - r, y: h))
                        p.addArc(center: CGPoint(x: w - r, y: h - r), radius: r, startAngle: .degrees(90), endAngle: .degrees(0), clockwise: true)
                        p.addLine(to: CGPoint(x: w, y: h - r - cornerLength))
                    }
                }
                .stroke(Theme.accent, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
            }
        }
    }
}

// MARK: - Scanning animation
private struct ScanningAnimation: View {
    @State private var offset: CGFloat = -130

    var body: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [Color.clear, Theme.accent.opacity(0.6), Color.clear],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(height: 4)
            .offset(y: offset)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.2).repeatForever(autoreverses: true)) {
                    offset = 130
                }
            }
    }
}

// MARK: - Detected result card
private struct DetectedResultCard: View {
    let size: Double
    let onConfirm: () -> Void
    let onRetry: () -> Void

    var body: some View {
        VStack(spacing: 16) {
            VStack(spacing: 6) {
                HStack(spacing: 8) {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(Theme.accent)
                    Text("Detected")
                        .font(AppFont.caption(13, weight: .semibold))
                        .foregroundColor(Theme.textSecondary)
                }
                Text("\(size.formatted(.number.precision(.fractionLength(1)))) qt")
                    .font(AppFont.display(36))
                    .foregroundColor(Theme.textPrimary)
            }

            HStack(spacing: 12) {
                SecondaryButton("Retry", icon: "arrow.counterclockwise", action: onRetry)
                PrimaryButton("Confirm", icon: "checkmark", action: onConfirm)
            }
        }
        .padding(Theme.marginLarge)
        .background(.ultraThinMaterial)
        .clipShape(RoundedRectangle(cornerRadius: Theme.radiusL))
        .overlay(
            RoundedRectangle(cornerRadius: Theme.radiusL)
                .stroke(Theme.accent.opacity(0.2), lineWidth: 1)
        )
    }
}

// MARK: - Manual size entry sheet
private struct ManualSizeSheet: View {
    let recipe: Recipe
    @Binding var path: NavigationPath
    @Environment(\.dismiss) private var dismiss
    @State private var sizeText = ""

    var parsedSize: Double? { Double(sizeText) }

    var body: some View {
        NavigationStack {
            ZStack {
                Theme.backgroundGradient.ignoresSafeArea()

                VStack(spacing: 24) {
                    Text("Enter pot size in quarts")
                        .font(AppFont.subheading())
                        .foregroundColor(Theme.textPrimary)

                    HStack(alignment: .lastTextBaseline, spacing: 6) {
                        TextField("3.2", text: $sizeText)
                            .font(AppFont.display(48))
                            .foregroundColor(Theme.textPrimary)
                            .tint(Theme.accent)
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.center)
                            .frame(width: 160)
                        Text("qt")
                            .font(AppFont.heading(24))
                            .foregroundColor(Theme.textSecondary)
                    }

                    // Quick select buttons
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Common sizes")
                            .font(AppFont.caption())
                            .foregroundColor(Theme.textSecondary)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 8) {
                                ForEach([1.5, 2.0, 3.0, 4.0, 5.5, 6.0, 8.0], id: \.self) { s in
                                    Button { sizeText = s.formatted(.number.precision(.fractionLength(0...1))) } label: {
                                        Text("\(s.formatted(.number.precision(.fractionLength(0...1)))) qt")
                                            .font(AppFont.caption(13, weight: .semibold))
                                            .foregroundColor(sizeText == s.formatted(.number.precision(.fractionLength(0...1))) ? .white : Theme.textSecondary)
                                            .padding(.horizontal, 14)
                                            .padding(.vertical, 8)
                                            .background(
                                                sizeText == s.formatted(.number.precision(.fractionLength(0...1)))
                                                    ? AnyView(Theme.accentGradient)
                                                    : AnyView(Theme.surface)
                                            )
                                            .clipShape(RoundedRectangle(cornerRadius: Theme.radiusFull))
                                            .overlay(
                                                RoundedRectangle(cornerRadius: Theme.radiusFull)
                                                    .stroke(Theme.border, lineWidth: 1)
                                            )
                                    }
                                    .buttonStyle(.plain)
                                }
                            }
                        }
                    }

                    Spacer()

                    PrimaryButton("Use This Size", icon: "checkmark") {
                        guard let size = parsedSize else { return }
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            let result = ScaledResult(recipe: recipe, detectedQuarts: size)
                            path.append(Route.result(result))
                        }
                    }
                    .disabled(parsedSize == nil)
                    .opacity(parsedSize == nil ? 0.5 : 1)
                }
                .padding(Theme.marginLarge)
            }
            .navigationTitle("Manual Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                        .foregroundColor(Theme.accent)
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    @Previewable @State var path = NavigationPath()
    NavigationStack {
        ScanPotView(recipe: MockData.recipes[0], path: $path)
    }
}
