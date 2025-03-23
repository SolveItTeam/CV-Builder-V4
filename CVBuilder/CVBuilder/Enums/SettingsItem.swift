import Foundation

enum SettingsItem: CaseIterable {
    case rateUs, shareApp, contactUs, privacyPolicy, termsOfUse
    
    var icon: ImageResource {
        switch self {
        case .rateUs:
            return .rateUs
        case .shareApp:
            return .shareapp
        case .contactUs:
            return .contactUs
        case .privacyPolicy:
            return .privacy
        case .termsOfUse:
            return .terms
        }
    }
    
    var title: String {
        switch self {
        case .shareApp:
            return R.string.localizable.shareApp()
        case .contactUs:
            return R.string.localizable.contactUs()
        case .rateUs:
            return R.string.localizable.rateUs()
        case .privacyPolicy:
            return R.string.localizable.privacyPolicy()
        case .termsOfUse:
            return R.string.localizable.termsOfUse()
        }
    }
}
