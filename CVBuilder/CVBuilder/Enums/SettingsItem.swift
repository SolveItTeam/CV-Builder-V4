import Foundation

enum SettingsItem: CaseIterable {
    case rateUs, shareApp, restore, privacyPolicy, termsOfUse
    
    var icon: ImageResource {
        switch self {
        case .rateUs:
            return .woman
        case .shareApp:
            return .woman
        case .restore:
            return .woman
        case .privacyPolicy:
            return .woman
        case .termsOfUse:
            return .woman
        }
    }
    
    var title: LocalizedStringResource {
        switch self {
        case .shareApp:
            return ""
        case .restore:
            return ""
        case .rateUs:
            return ""
        case .privacyPolicy:
            return ""
        case .termsOfUse:
            return ""
        }
    }
}
