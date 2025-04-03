import SwiftUI


final class HomeViewModel: ObservableObject {
    @Published var showProIcon: Bool
    @Published var historyItems: [HistoryItem] = []
    
    private let coordinator: Coordinator
    
    private let purchaseManager: PurchaseManager = .shared
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        
        showProIcon = !purchaseManager.isPremium
        
        purchaseManager.$isPremium
            .map { !$0 }
            .assign(to: &$showProIcon)
        
        fetchHistory()
    }
    
    func showPaywall() {
        coordinator.showPaywall()
    }
    
    func showResumeTemplates() {
        coordinator.showResumeTemplates()
        
    }
    
    func showAllResumes() {
        coordinator.showFullHistory()
    }
    
    func showPreview(cvtemplate: CVTemplate) {
        coordinator.showTemplatePreview(cvTemplate: cvtemplate)
    }
    
    func openResultView(historyItem: HistoryItem) {
        coordinator.showHistoryItem(historyItem: historyItem)
    }
    
    
    func fetchHistory() {
        Task {
            let items = HistoryItemRepository.shared.fetchAll()
            await MainActor.run {
                self.historyItems = items
            }
        }
    }
    
    func deleteItem(_ item: HistoryItem) {
        HistoryItemRepository.shared.delete(item)
        fetchHistory()
    }
}
