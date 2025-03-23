import SwiftUI
import Combine

final class SettingsViewModel: ObservableObject {
    @Published var isLoading: Bool = false
    @Published var showProIcon: Bool
    @Published var isShowingAlert: Bool = false
    @Published var errorMessage: AppError = .raw(title: R.string.localizable.somethingWentWrong(), subTitle: R.string.localizable.pleaseTryAgain())
    
    private var cancellables = Set<AnyCancellable>()
    private let coordinator: Coordinator
    private let purchaseManager: PurchaseManager = .shared
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        
        showProIcon = !purchaseManager.isPremium
        
        purchaseManager.$isPremium
            .map { !$0 }
            .assign(to: &$showProIcon)
    }
    
    func itemTapped(_ chosenItem: SettingsItem) {
        switch chosenItem {
        case .shareApp:
            shareApp()
        case .contactUs:
            occureImpact()
            coordinator.openContactUs()
        case .rateUs:
            rateApp()
        case .privacyPolicy:
            showPrivacy()
        case .termsOfUse:
            showTerms()
        }
    }
    
    func popView() {
        occureImpact()
        coordinator.popView()
    }
    
    func showPaywall() {
        occureImpact()
        coordinator.showPaywall()
    }
    
    func rateApp() {
        occureImpact()
        coordinator.showRateUs()
    }
    
    func shareApp() {
        occureImpact()
        coordinator.showShareApp()
    }
     
    func showPrivacy() {
        occureImpact()
        coordinator.showPrivacyPolicy()
    }
    
    func showTerms() {
        occureImpact()
        coordinator.showTermsOfUse()
    }
 
}
