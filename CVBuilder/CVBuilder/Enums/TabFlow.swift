import Foundation

enum TabFlow: Int, CaseIterable {
    case home = 0, profile, plus, history, settings

    var id: Int {
        return self.rawValue
    }
  
    var active: ImageResource {
        switch self {
        case .home:
            return .home
        case .profile:
            return .profile
        case .plus:
            return .plus
        case .history:
            return .history
        case .settings:
            return .settings
        }
    }
}
