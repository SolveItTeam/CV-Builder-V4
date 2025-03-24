
import SwiftUI
import Reachability
import Adapty
import Combine
import AVFoundation

final class OnboardingViewModel: ObservableObject {
    @Published var appProducts: [AdaptyPaywallProduct] = []
    @Published var isShowingAlert: Bool = false
    @Published var alertCategory: AlertType = .cancelles
    @Published var errorHandler: AppError = .raw(title: R.string.localizable.somethingWentWrong(), subTitle: R.string.localizable.pleaseTryAgain())
    @Published var weekOffer: String
    @Published var isProductsLoading: Bool = false
    @Published var needCloseDisabling = true
    @Published var isWithFreeTrial: Bool = false
    var finishedOnboarding: () -> Void
    
    @Published var purchaseService: PurchaseManager = .shared
    var isAppRateShown: Bool = false
    private var network: Reachability?
    private var cancellables = Set<AnyCancellable>()
    let remoteConfig: AppRemoteConfigService
    private let coordinator: Coordinator

    init(
        coordinator: Coordinator,
        remoteConfig: AppRemoteConfigService = .shared,
        finishedOnboarding: @escaping () -> Void
    ) {
        self.remoteConfig = remoteConfig
        self.coordinator = coordinator
        self.finishedOnboarding = finishedOnboarding
        network = try? Reachability()
        weekOffer = "6,99$"
    }
    var crossDisabledDuration: Double {
        return Double(remoteConfig.config.paywallConfig.closeActionDuration)
    }
    
    var closOpacity: Double {
        return Double(remoteConfig.config.paywallConfig.closOpacity)
    }
    deinit {
        network?.stopNotifier()
    }
    
    func onNotNowTapped() {
        occureImpact()
        finishedOnboarding()
    }
    
    func onPrivacyPolicyTapped() {
        coordinator.showPrivacyPolicy()
    }
    
    func onTermsOfUseTapped() {
        coordinator.showTermsOfUse()
    }
    
    func endAppRatinCall() {
        isAppRateShown = true
    }
    
    func restoreTapped() async {
        await MainActor.run { [weak self] in
            self?.occureImpact()
            self?.isProductsLoading = true
        }
        
        do {
            try await purchaseService.restorePurchases()
            await MainActor.run { [weak self] in
                guard let self else { return }
                if purchaseService.isPremium {
                    errorHandler = .raw(title: R.string.localizable.restoreSuccessedTitle(), subTitle: R.string.localizable.restoreSuccessedSubTitle())
                    isShowingAlert = true
                    alertCategory = .common
                } else {
                    errorHandler = .raw(title: R.string.localizable.noActiveSubscriptionTitle(), subTitle: R.string.localizable.noActiveSubscriptionSubTitle())
                    isShowingAlert = true
                    alertCategory = .common
                }
            }
        } catch {
            if let adaptyError = error as? AdaptyError {
                let errorManager = AdaptyErrorManager(error: adaptyError)
                print(errorManager.log)
                await MainActor.run { [weak self] in
                    guard let self = self else { return }
                    self.errorHandler = .raw(title: errorManager.log, subTitle: R.string.localizable.anErrorOccured())
                    self.isShowingAlert = true
                    self.alertCategory = .common
                }
            }
        }
        
        await MainActor.run { [weak self] in
            self?.isProductsLoading = false
        }
    }
    
    func loadPaywall(placementId: PlacementId) async {
        do {
            let paywall = try await purchaseService.fetchAdaptyPaywall(placementId: placementId)
            await loadPayWallProducts(paywall: paywall)
        }  catch {
            if let adaptyError = error as? AdaptyError {
                let errorManager = AdaptyErrorManager(error: adaptyError)
                print(errorManager.log)
                await MainActor.run { [weak self] in
                    guard let self = self else { return }
                    self.errorHandler = .raw(title: errorManager.log, subTitle: R.string.localizable.anErrorOccured())
                    self.isShowingAlert = true
                    self.alertCategory = .common
                }
            }
        }
    }
    
    
    private func loadPayWallProducts(paywall: AdaptyPaywall) async {
        do {
            let products = try await purchaseService.fetchAdaptyPaywallProducts(adaptyPaywall: paywall)
            await MainActor.run { [weak self] in
                guard let self else { return }
                appProducts = products
                if let firstProduct = appProducts.first(where: { $0.vendorProductId == "Weekly" }) {
                    
                    
                    if let symbol = firstProduct.currencySymbol {
                        let formatter = NumberFormatter()
                        formatter.numberStyle = .decimal
                        formatter.minimumFractionDigits = 2
                        formatter.maximumFractionDigits = 2
                        
                        if let formattedPrice = formatter.string(from: firstProduct.price as NSNumber) {
                            let combinedPrice = "\(symbol)\(formattedPrice)"
                            weekOffer = combinedPrice
                        }
                    }
                } else if let product = appProducts.first {
                    
                    if let symbol = product.currencySymbol {
                        let formatter = NumberFormatter()
                        formatter.numberStyle = .decimal
                        formatter.minimumFractionDigits = 2
                        formatter.maximumFractionDigits = 2
                        
                        if let formattedPrice = formatter.string(from: product.price as NSNumber) {
                            let combinedPrice = "\(symbol)\(formattedPrice)"
                            weekOffer = combinedPrice
                        }
                    }
                }
                
                if appProducts.first(where: { $0.subscriptionOffer?.offerType == .introductory}) != nil {
                    isWithFreeTrial = true
                }
            }
        } catch {
            if let adaptyError = error as? AdaptyError {
                let errorManager = AdaptyErrorManager(error: adaptyError)
                print(errorManager.log)
                await MainActor.run { [weak self] in
                    guard let self = self else { return }
                    self.errorHandler = .raw(title: errorManager.log, subTitle: R.string.localizable.anErrorOccured())
                    self.isShowingAlert = true
                    self.alertCategory = .common
                }
            }
        }
    }
    
    func processPurchase() async {
        guard let product = appProducts.first(where: { $0.localizedTitle == ProductTitle.weeklyProductTitle }) else {
            await MainActor.run { [weak self] in
                self?.errorHandler = .raw(title: R.string.localizable.no_product_ids_found(), subTitle: R.string.localizable.pleaseTryAgain())
                self?.isShowingAlert = true
                self?.alertCategory = .common
            }
            return
        }
        
        await MainActor.run { [weak self] in
            self?.occureImpact()
            self?.isProductsLoading = true
        }
        
        var isCancelled = false
        
        do {
            isCancelled = try await purchaseService.executePurchase(adaptyPaywalProduct: product)
            if purchaseService.isPremium {
                await MainActor.run { [weak self] in
                    self?.onNotNowTapped()
                }
            }
            
            if isCancelled {
                try await Task.sleep(nanoseconds: 300_000_000)
                await MainActor.run { [weak self] in
                    self?.errorHandler = .raw(title: R.string.localizable.somethingWentWrong(), subTitle: R.string.localizable.pleaseTryAgain())
                    self?.isShowingAlert = true
                    self?.alertCategory = .cancelles
                    self?.occureImpact()
                }
            }
        } catch {
            if let adaptyError = error as? AdaptyError {
                let errorManager = AdaptyErrorManager(error: adaptyError)
                print(errorManager.log)
                await MainActor.run { [weak self] in
                    guard let self = self else { return }
                    self.errorHandler = .raw(title: errorManager.log, subTitle: R.string.localizable.somethingWentWrong())
                    self.isShowingAlert = true
                    self.alertCategory = .cancelles
                }
            }
        }
        
        await MainActor.run { [weak self] in
            self?.isProductsLoading = false
        }
    }
    
    func requestAppRate() {
        coordinator.showRateUs()
    }
    
    private func setupReachability() {
        network?.whenReachable = { [weak self] _ in
            self?.isShowingAlert = false
        }
        
        network?.whenUnreachable = { [weak self] _ in
            self?.alertCategory = .common
            self?.errorHandler = .raw(title: R.string.localizable.noInternetConnection(), subTitle: R.string.localizable.pleaseTurnOnTheInternet())
            self?.isShowingAlert = true
        }
    }
}
