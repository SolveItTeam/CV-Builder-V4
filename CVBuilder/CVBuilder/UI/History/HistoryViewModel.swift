import SwiftUI


final class HistoryViewModel: ObservableObject {
    @Published var showProIcon: Bool
    private let coordinator: Coordinator
    
    private let purchaseManager: PurchaseManager = .shared
 
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        
        showProIcon = !purchaseManager.isPremium
        
        purchaseManager.$isPremium
            .map { !$0 }
            .assign(to: &$showProIcon)
    }
    
    func showPaywall() {
        coordinator.showPaywall()
    }
    
    func showResumeTemplates() {
        coordinator.showResumeTemplates()
    }
    
    func backTapped() {
        coordinator.popView()
    }
}
