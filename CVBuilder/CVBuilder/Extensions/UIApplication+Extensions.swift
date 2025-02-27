import UIKit
import StoreKit
import SafariServices

extension UIApplication {
    func actionSheetShare(localizedShareText: String) {
        let uIActivityViewController = UIActivityViewController(
            activityItems: [
                localizedShareText,
                ConfigValues.getValue().appId
            ],
            applicationActivities: nil
        )
        
        if UIDevice.current.userInterfaceIdiom == .pad {
            if let popoverController = uIActivityViewController.popoverPresentationController {
                popoverController.sourceView = lastVC?.view
                popoverController.sourceRect = CGRect(x: (UIScreen.main.bounds.minX + UIScreen.main.bounds.midX) / 2 , y: (UIScreen.main.bounds.minY + UIScreen.main.bounds.midY) / 2, width: 0, height: 0)
                popoverController.permittedArrowDirections = []
            }
        }
        
        lastVC?.present(uIActivityViewController, animated: true)
    }
    
    var topInset: CGFloat {
        return UIApplication.shared.lastVC?.navigationController?.navigationBar.frame.height ?? UIApplication.shared.statusBarFrame.size.height
    }
    
    var lastVC: UIViewController? {
        var topViewController = connectedScenes.compactMap {
            return ($0 as? UIWindowScene)?.windows
                                          .filter { $0.isKeyWindow  }
                                          .first?
                                          .rootViewController
        }
        .first
        
        if let presented = topViewController?.presentedViewController {
            topViewController = presented
        } else if let navController = topViewController as? UINavigationController {
            topViewController = navController.topViewController
        } else if let tabBarController = topViewController as? UITabBarController {
            topViewController = tabBarController.selectedViewController
        }
        return topViewController
    }
    
    var topVC: UIViewController? {
        guard let keyWindow = self.connectedScenes
                .filter({ $0.activationState == .foregroundActive })
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow }) else {
            return nil
        }
        
        var topController = keyWindow.rootViewController
        while let presented = topController?.presentedViewController {
            topController = presented
        }
        
        if let navController = topController as? UINavigationController {
            topController = navController.visibleViewController
        }
        
        if let tabBarController = topController as? UITabBarController {
            topController = tabBarController.selectedViewController
        }
        
        return topController
    }
    
    func requestReview() {
        guard let scene = foregroundActiveWindowScene else { return }
        SKStoreReviewController.requestReview(in: scene)
    }
    
    func termsPolicy() {
        openSafariWebController(for: URL(string: ConfigValues.getValue().terms)!)
    }
    
    func privacyPolicy() {
        openSafariWebController(for: URL(string: ConfigValues.getValue().privacy)!)
    }
}

private extension UIApplication {
    var foregroundActiveWindowScene: UIWindowScene? {
        connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
    }
    
    func openSafariWebController(for url: URL) {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
        let vc = SFSafariViewController(url: url, configuration: config)
        lastVC?.present(vc, animated: true)
    }
}
