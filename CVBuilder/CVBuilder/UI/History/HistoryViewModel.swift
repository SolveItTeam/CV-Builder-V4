import SwiftUI
import Combine

final class HistoryViewModel: ObservableObject {
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
    
    func openResultView(historyItem: HistoryItem) {
        coordinator.showHistoryItem(historyItem: historyItem)
    }
    
    func backTapped() {
        coordinator.popView()
    }
    
    func rename(_ item: HistoryItem, jobTitle: String) {
        HistoryItemRepository.shared.renameHistoryItem(item, newJobTitle: jobTitle)
        objectWillChange.send()
    }
    
    func deleteItem(_ item: HistoryItem) {
        HistoryItemRepository.shared.deleteHistoryItem(item)
        objectWillChange.send()
    }
}
