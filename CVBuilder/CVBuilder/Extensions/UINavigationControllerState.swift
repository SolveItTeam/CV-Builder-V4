import UIKit


struct UINavigationControllerState {
    static var shared = UINavigationControllerState()
    var allowsSwipeBack: Bool = true
}


extension UINavigationController: @retroactive UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }
    
    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard UINavigationControllerState.shared.allowsSwipeBack else { return false }
        
        return viewControllers.count > 1
    }
}
