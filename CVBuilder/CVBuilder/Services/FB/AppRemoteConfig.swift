import Foundation

struct AppRemoteConfig: Codable {
    struct PaywallConfig: Codable {
        let isPriceTitle: Bool
        let closeActionDuration: Double
        let closOpacity: Double
    }

    let paywallConfig: PaywallConfig
    let freeTries: Int
    let enabledAppRatingRequest: Bool
    let isNavButtonAnimated: Bool
    
    static var `default`: AppRemoteConfig {
        .init(
            paywallConfig: PaywallConfig(
                isPriceTitle: false,
                closeActionDuration: 0.0,
                closOpacity: 1.0
            ),
            freeTries: 1,
            enabledAppRatingRequest: false,
            isNavButtonAnimated: false
        )
    }
}
