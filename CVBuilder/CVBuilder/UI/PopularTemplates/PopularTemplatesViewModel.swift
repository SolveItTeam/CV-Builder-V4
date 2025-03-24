import SwiftUI

struct CVTemplate: Identifiable, Hashable {
    let id: UUID = UUID()
    let templatePreview: ImageResource
    let fileToUseString: String
}

let templatesList: [CVTemplate] = [
    CVTemplate(templatePreview: .template1, fileToUseString: "template1.pdf"),
    CVTemplate(templatePreview: .template2, fileToUseString: "template2.pdf"),
    CVTemplate(templatePreview: .template3, fileToUseString: "template3.pdf"),
    CVTemplate(templatePreview: .template4, fileToUseString: "template4.pdf"),
    CVTemplate(templatePreview: .template5, fileToUseString: "template5.pdf"),
    CVTemplate(templatePreview: .template6, fileToUseString: "template6.pdf"),
    CVTemplate(templatePreview: .template7, fileToUseString: "template7.pdf"),
    CVTemplate(templatePreview: .template8, fileToUseString: "template8.pdf") 
]

final class PopularTemplatesViewModel: ObservableObject {
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
    
    func backTapped() {
        coordinator.popView()
    }
    
    func showPreview(cvtemplate: CVTemplate) {
        coordinator.showTemplatePreview(cvTemplate: cvtemplate)
    }
}
