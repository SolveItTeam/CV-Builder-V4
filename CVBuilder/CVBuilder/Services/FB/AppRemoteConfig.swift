import Foundation

struct AppRemoteConfig: Codable {
    struct PaywallConfig: Codable {
        let isPriceTitle: Bool
    }

    let paywallConfig: PaywallConfig
    let freeTries: Int
    let enabledAppRatingRequest: Bool
    let isNavButtonAnimated: Bool
    
    static var `default`: AppRemoteConfig {
        .init(
            paywallConfig: PaywallConfig(
                isPriceTitle: false
            ),
            freeTries: 1,
            enabledAppRatingRequest: false,
            isNavButtonAnimated: false
        )
    }
}
