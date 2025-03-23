import SwiftUI

extension ObservableObject {
    func occureImpact() {
        UIImpactFeedbackGenerator(style: .light).impactOccurred()
    }
}
