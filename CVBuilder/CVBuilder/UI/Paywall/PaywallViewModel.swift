
import SwiftUI
import Adapty
import Combine
import Reachability

enum SubscriptionPeriod {
    case weekly
    case monthly
    case annual
}

final class PaywallViewModel: ObservableObject {
    @Published var adaptyProducts: [AdaptyPaywallProduct] = []
    @Published var appProducts: [Product] = []
    @Published var isShowingAlert: Bool = false
    @Published var alertCategory: AlertType = .common
    @Published var errorHandler: AppError = .raw(title: R.string.localizable.somethingWentWrong(), subTitle: R.string.localizable.pleaseTryAgain())
    @Published var isLoading: Bool = false
    @Published var isWithFreeTrial: Bool = false
    @Published var selectedProduct: Product?
    @Published var weekPrice: String = "$6,99"
    
    var reachibillity: Reachability?
    let purchaseService: PurchaseManager = .shared
    let remoteConfig: AppRemoteConfigService = .shared
    private let coordinator: Coordinator
    private var cancellables = Set<AnyCancellable>()
    

    var crossDisabledDuration: Double {
        return Double(remoteConfig.config.paywallConfig.closeActionDuration)
    }
    
    var closOpacity: Double {
        return Double(remoteConfig.config.paywallConfig.closOpacity)
    }
    
    var subtitle: String {
        guard let selectedProduct else { return "" }
        var priceText: String = ""
        switch selectedProduct.localizedTitle.lowercased() {
 
        case ProductTitle.monthlyProductTitle.lowercased():
            priceText += selectedProduct.localizedPrice
            priceText += " "
            priceText += R.string.localizable.perMonth()
        case ProductTitle.yearlyProductTitle.lowercased():
 
            priceText += selectedProduct.localizedPrice
            priceText += " "
            priceText += R.string.localizable.perYear()
        default:
            priceText = R.string.localizable.threeDaysTrial()
            priceText += " "
            priceText += selectedProduct.localizedPrice
            priceText += " "
            priceText += R.string.localizable.perWeek()
        }

        
        return R.string.localizable.startToContinueAppWith(priceText)
        
     
    }
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        reachibillity = try? Reachability()
        purchaseService.$isPremium
            .receive(on: RunLoop.main)
            .sink { [weak self] isPremium in
                guard let self else { return }
                if isPremium {
                    occureImpact()
                    closePaywall()
                }
            }
            .store(in: &cancellables)
    }
    
    func closePaywall() {
        coordinator.dismissSheet()
    }
    
    func onContinueButtonPressed() {
        Task {
            await processPurchase()
        }
    }
    
    func formatWeekPrice(price: String) -> String {
        return R.string.localizable.then() + " "  + price.replacingOccurrences(of: "\u{00A0}", with: "")
    }
    
    func formatPrice(price: String, description: String) -> String {
        return price.replacingOccurrences(of: "\u{00A0}", with: "") + "/" + description
    }
    
    func parsePrice(_ priceString: String) -> (symbol: String?, amount: Double?) {
        let trimmedPrice = priceString
            .replacingOccurrences(of: "\u{00A0}", with: "")
            .trimmingCharacters(in: .whitespacesAndNewlines)
        
        let digits = CharacterSet.decimalDigits.union(CharacterSet(charactersIn: ".,"))
        
        guard let firstNumericIndex = trimmedPrice.firstIndex(where: { char in
            guard let scalar = char.unicodeScalars.first else { return false }
            return digits.contains(scalar)
        }) else {
            return (nil, nil)
        }
        
        let symbol = String(trimmedPrice[..<firstNumericIndex])
        let numericPart = String(trimmedPrice[firstNumericIndex...])
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.locale = Locale.current
        
        if let number = formatter.number(from: numericPart) {
            return (symbol, number.doubleValue)
        }
        
        return (symbol, nil)
    }
    
    func formatForWeekPrice(from priceString: String?, period: SubscriptionPeriod) -> String {
        guard let priceString = priceString, !priceString.isEmpty else { return "" }

        let cleanPriceString = priceString.replacingOccurrences(of: "\u{00A0}", with: "")
        let (currencySymbol, numericValue) = parsePrice(cleanPriceString)
        guard let amount = numericValue, let symbol = currencySymbol else {
            return ""
        }
        
        let weeklyPrice: Double
        switch period {
        case .weekly:
            weeklyPrice = amount
        case .monthly:
            weeklyPrice = amount / 4.345
        case .annual:
            weeklyPrice = amount / 52
        }
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.locale = Locale.current
        formatter.currencySymbol = symbol
        formatter.minimumFractionDigits = 2
        formatter.maximumFractionDigits = 2
        
        return formatter.string(from: NSNumber(value: weeklyPrice)) ?? ""
    }

    var navigationTitle: String {
        guard remoteConfig.config.paywallConfig.isPriceTitle else {
            return R.string.localizable.continue()
        }
        
        let startTitle = R.string.localizable.start()
        
        var priceText = selectedProduct?.localizedPrice ?? ""
        
        priceText += "/" + NSLocalizedString(selectedProduct?.localizedTitle.lowercased() ?? "", comment: "")
        
        return startTitle + " " + priceText
    }
    
    func loadPaywall(placementId: PlacementId) async {
        await MainActor.run { [weak self] in
            self?.isLoading = true
        }
        
        do {
            let paywall = try await purchaseService.fetchAdaptyPaywall(placementId: placementId)
            await loadPaywallProducts(paywall: paywall)
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
            self?.isLoading = false
        }
    }
    
    private func loadPaywallProducts(paywall: AdaptyPaywall) async {
        do {
            let products = try await purchaseService.fetchAdaptyPaywallProducts(adaptyPaywall: paywall)
            await MainActor.run { [weak self] in
                guard let self else { return }
                adaptyProducts = products
                
                appProducts = adaptyProducts.compactMap { product in
                    print(product.localizedTitle)
                    if let symbol = product.currencySymbol {
                        let formatter = NumberFormatter()
                        formatter.numberStyle = .decimal
                        formatter.minimumFractionDigits = 2
                        formatter.maximumFractionDigits = 2
                        
                        if let formattedPrice = formatter.string(from: product.price as NSNumber) {
                            let combinedPrice = "\(symbol)\(formattedPrice)"
                            return Product(
                                id: UUID(),
                                vendorProductId: product.vendorProductId,
                                localizedPrice: combinedPrice,
                                localizedTitle: product.localizedTitle,
                                localizedDescription: product.localizedDescription
                            )
                        }
                    }
                    
                    return nil
                }
                
                self.freeTrialSync()
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
    
    func selectProduct(product: Product) {
        occureImpact()
        selectedProduct = product
    }
    
    func freeTrialSync() {
        if adaptyProducts.first(where: { $0.subscriptionOffer?.offerType == .introductory}) != nil {
            isWithFreeTrial = true
        }
        
        if let firstProduct = appProducts.first {
            selectedProduct = firstProduct
            weekPrice = firstProduct.localizedPrice
        }
    }
    
    func processPurchase() async {
        guard reachibillity?.connection != .unavailable else {
            errorHandler = .raw(title: R.string.localizable.noInternetConnection(), subTitle: R.string.localizable.pleaseTurnOnTheInternet())
            isShowingAlert = true
            alertCategory = .common
            return
        }
        
        guard let _ = appProducts.first else {
            await MainActor.run { [weak self] in
                self?.errorHandler = .raw(title: R.string.localizable.no_product_ids_found(), subTitle: R.string.localizable.pleaseTryAgain())
                self?.isShowingAlert = true
                self?.alertCategory = .common
            }
            return
        }
        
        await MainActor.run { [weak self] in
            self?.occureImpact()
            self?.isLoading = true
        }
        
        var isCancelled = false
        
        do {
            if let selectedProduct, let product = adaptyProducts.first(where: { $0.vendorProductId == selectedProduct.vendorProductId }) {
                isCancelled = try await purchaseService.executePurchase(adaptyPaywalProduct: product)
            } else {
                errorHandler = .raw(title: R.string.localizable.no_product_ids_found(), subTitle: R.string.localizable.pleaseTryAgain())
                isShowingAlert = true
                alertCategory = .common
                isLoading = false
            }
            
            if purchaseService.isPremium {
                await MainActor.run { [weak self] in
                    guard let self else { return }
                    occureImpact()
                    closePaywall()
                }
            }
            
            if isCancelled {
                try await Task.sleep(nanoseconds: 300_000_000)
                await MainActor.run { [weak self] in
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
            self?.isLoading = false
        }
    }
    
    func onRestoreTapped() async {
        await MainActor.run { [weak self] in
            self?.occureImpact()
            self?.isLoading = true
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
                    self.errorHandler = .raw(title: errorManager.log, subTitle: R.string.localizable.somethingWentWrong())
                    self.isShowingAlert = true
                    self.alertCategory = .common
                }
            }
        }
        
        await MainActor.run { [weak self] in
            self?.isLoading = false
        }
    }
    
    func onPrivacyPolicyTapped() {
        UIApplication.shared.privacyPolicy()
    }
    
    func onTermsOfUseTapped() {
        UIApplication.shared.termsPolicy()
    }
}
