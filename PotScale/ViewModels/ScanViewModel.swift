import SwiftUI

@MainActor
final class ScanViewModel: ObservableObject {
    enum ScanState {
        case idle
        case scanning
        case detected(Double)
    }

    @Published var state: ScanState = .idle
    @Published var manualSizeText: String = ""

    func startScan() {
        withAnimation(.easeInOut(duration: 0.3)) {
            state = .scanning
        }
        Task {
            try? await Task.sleep(for: .seconds(2))
            withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
                state = .detected(MockData.defaultDetected)
            }
        }
    }

    func retry() {
        withAnimation {
            state = .idle
        }
    }

    var detectedSize: Double? {
        if case .detected(let size) = state { return size }
        return nil
    }

    var isScanning: Bool {
        if case .scanning = state { return true }
        return false
    }
}
