import SwiftUI


final class TemplatePreviewViewModel: ObservableObject {
    @Published var showProIcon: Bool
    private let coordinator: Coordinator
    
    private let purchaseManager: PurchaseManager = .shared
    @Published var chosenTemplate: CVTemplate
    @Published var currentIndex: Int
    init(coordinator: Coordinator, chosenTemplate: CVTemplate) {
        self.coordinator = coordinator
        self.chosenTemplate = chosenTemplate
        showProIcon = !purchaseManager.isPremium
        currentIndex = templatesList.firstIndex(where: { $0.fileToUseString == chosenTemplate.fileToUseString } ) ?? 0
        purchaseManager.$isPremium
            .map { !$0 }
            .assign(to: &$showProIcon)
    }
    
    func showPaywall() {
        coordinator.showPaywall()
    }
    
    func backTapped() {
        coordinator.popView()
    }
}
