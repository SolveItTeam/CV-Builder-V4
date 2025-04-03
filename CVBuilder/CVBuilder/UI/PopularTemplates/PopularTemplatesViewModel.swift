import SwiftUI

struct CVTemplate: Identifiable, Hashable {
    let id: UUID = UUID()
    let num: Int
    let templatePreview: ImageResource
    let fileToUseString: String
}

let templatesList: [CVTemplate] = [
    CVTemplate(num: 1, templatePreview: .template1, fileToUseString: "template1.pdf"),
    CVTemplate(num: 2,templatePreview: .template3, fileToUseString: "template3.pdf"),
    CVTemplate(num: 3,templatePreview: .template4, fileToUseString: "template4.pdf"),
    CVTemplate(num: 4,templatePreview: .template5, fileToUseString: "template5.pdf"),
    CVTemplate(num: 5,templatePreview: .template6, fileToUseString: "template6.pdf"),
    CVTemplate(num: 6,templatePreview: .template7, fileToUseString: "template7.pdf"),
    CVTemplate(num: 7,templatePreview: .template8, fileToUseString: "template8.pdf")
]

final class PopularTemplatesViewModel: ObservableObject {
    @Published var showProIcon: Bool
    private let coordinator: Coordinator
    
    private let purchaseManager: PurchaseManager = .shared
    let isFromPush: Bool
    
    init(coordinator: Coordinator, isFromPush: Bool) {
        self.coordinator = coordinator
        self.isFromPush = isFromPush
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
