import SwiftUI
import Combine

final class HomeViewModel: ObservableObject {
    @Published var showProIcon: Bool
    @Published var repository: HistoryItemRepository = .shared
    @Published var historyItems: [HistoryItem] = []
    
    private let coordinator: Coordinator
    private var cancellables = Set<AnyCancellable>()
    private let purchaseManager: PurchaseManager = .shared
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        
        showProIcon = !purchaseManager.isPremium
        
        purchaseManager.$isPremium
            .map { !$0 }
            .assign(to: &$showProIcon)
        
        repository.$historyItems
            .assign(to: \.historyItems, on: self)
            .store(in: &cancellables)
         
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
    
    
    func deleteItem(_ item: HistoryItem) {
        HistoryItemRepository.shared.deleteHistoryItem(item)
        objectWillChange.send()
    }
}
