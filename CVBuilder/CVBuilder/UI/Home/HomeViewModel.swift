import SwiftUI


final class HomeViewModel: ObservableObject {
    
    private let coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func showPaywall() {
        coordinator.showPaywall()
    }
    
    func showResumeTemplates() {
        coordinator.showResumeTemplates()
        
    }
}
