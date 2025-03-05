import SwiftUI


final class SettingsViewModel: ObservableObject {
    
    private let coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}
