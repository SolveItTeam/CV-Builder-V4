//
//  PurchaseManager.swift
//  CVBuilder
//
//  Created by Roman on 27.02.25.
//


import Adapty
import UIKit

final class PurchaseManager: ObservableObject {
    static let shared = PurchaseManager()
    
    @Published var isPremium: Bool = false {
        didSet {
            keychain.user?.isPremium = isPremium
        }
    }
    
    let keychain: KeychainService
    private var user: User {
        if let user = keychain.user {
            return user
        } else {
            return User(
                id: UUID().uuidString,
                isPremium: false,
                savedData: CVConstructor(firstname: "", lastname: "", email: "", phone: "", summary: "", jobTitle: "", site: "", location: "", workExperience: [], education: [], skills: [], languages: [])
            )
        }
    }
    
    init() {
        keychain = .init()
        if let user = keychain.user {
            isPremium = user.isPremium
        }
        
        if keychain.user == nil  {
            keychain.user = user
        }
        
        Adapty.activate(ConfigValues.getValue().adapty,
                        customerUserId: keychain.user?.id)
        Adapty.delegate = self
        
        Task {
            await fetchAdaptyProfile()
        }
    }
    
    func fetchAdaptyPaywall(placementId: PlacementId) async throws -> AdaptyPaywall {
        try await Adapty.getPaywall(placementId: placementId.rawValue)
    }
    
    func fetchAdaptyPaywallProducts(adaptyPaywall: AdaptyPaywall) async throws -> [AdaptyPaywallProduct] {
        try await Adapty.logShowPaywall(adaptyPaywall)
        return try await Adapty.getPaywallProducts(paywall: adaptyPaywall)
    }
    
    func executePurchase(adaptyPaywalProduct: AdaptyPaywallProduct) async throws -> Bool {
        do {
            let purchases = try await Adapty.makePurchase(product: adaptyPaywalProduct)
            switch purchases {
            case .userCancelled:
                return true
            case .pending:
                return false
            case .success(profile: let profile, transaction: _):
                updatePremiumStatus(profile, product: adaptyPaywalProduct)
                return false
            }

        } catch {
            if let adaptyError = error as? AdaptyError {
                throw(adaptyError)
            }
            
            return false
        }
    }
    
    func restorePurchases() async throws {
        do {
            let profile = try await Adapty.restorePurchases()
            updatePremiumStatus(profile)
        } catch {
            if let adaptyError = error as? AdaptyError {
                print(adaptyError.description)
            }
        }
    }
    
    func fetchAdaptyProfile(isPremium: Bool = false) async {
        do {
            let profile = try await Adapty.getProfile()
            updatePremiumStatus(profile, isPremium: isPremium)
        } catch {
            if let adaptyError = error as? AdaptyError {
                print(adaptyError.description)
            }
        }
    }
    
    private func updatePremiumStatus(_ profile: AdaptyProfile, isPremium: Bool = false, product: AdaptyPaywallProduct? = nil) {
        let isPremium = profile.accessLevels.contains(where: { $0.value.isActive })
        keychain.user?.isPremium = isPremium
        self.isPremium = isPremium
        DispatchQueue.main.async {
            if isPremium {
                Coordinator.addShortcutActionMenu()
            } else {
                UIApplication.shared.shortcutItems?.removeAll()
            }
        }
    }
}

extension PurchaseManager: AdaptyDelegate {
    func didLoadLatestProfile(_ profile: AdaptyProfile) {
        updatePremiumStatus(profile)
    }
}
