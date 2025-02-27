import UIKit

enum Constants {
    static let screenHeight: CGFloat = UIScreen.main.bounds.height
    static let screenWidth: CGFloat = UIScreen.main.bounds.width
    static let smallScreenHeight: CGFloat = 700
    static let noBrowHeight: CGFloat = 750
    
    static var navBarHeight: CGFloat {
        return UIApplication.shared.topInset
    }
    
    static var isPad: Bool {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
    
    enum AppStorageKeys {
        static let isOnboardingCompleted = "isOnboardingCompleted"
    }
}
