import UIKit
import FirebaseCore

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    var shortCutItem: UIApplicationShortcutItem!
    private var navigationLayer: Coordinator!
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        self.window = window
        self.navigationLayer = .init(window: window)
        self.navigationLayer.start()
        
        guard let shortCut = connectionOptions.shortcutItem else  { return }
        shortCutItem = shortCut
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {}
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        guard let shortCutItem else { return }
        _ = handle(shortcutItem: shortCutItem)
    }
    
    func windowScene(
        _ windowScene: UIWindowScene,
        performActionFor shortcutItem: UIApplicationShortcutItem,
        completionHandler: @escaping (Bool) -> Void
    ) {
        let handled = handle(shortcutItem: shortcutItem)
        completionHandler(handled)
    }
    
    func handle(shortcutItem: UIApplicationShortcutItem) -> Bool {
        guard let shortCutItem = ActionTypeQuick(rawValue: shortcutItem.type) else { return false }
        
        switch shortCutItem {
        default:
            navigationLayer.openContactUs()
        }
        
        return true
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {}
}

