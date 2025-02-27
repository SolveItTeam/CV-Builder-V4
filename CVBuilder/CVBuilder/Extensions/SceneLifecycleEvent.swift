import UIKit
import Combine

typealias SceneLifecyclePublisher = AnyPublisher<SceneLifecycleEvent, Never>

enum SceneLifecycleEvent {
    case willEnterForeground
    case didEnterBackground
}

extension NotificationCenter {
    var sceneLifecycleEventPublisher: SceneLifecyclePublisher {
        let willEnterForeground = publisher(for: UIScene.willEnterForegroundNotification).map({ _ in SceneLifecycleEvent.willEnterForeground })
        let didEnterBackground = publisher(for: UIScene.didEnterBackgroundNotification).map({ _ in SceneLifecycleEvent.didEnterBackground })
        return Publishers.Merge(willEnterForeground, didEnterBackground).eraseToAnyPublisher()
    }
}
