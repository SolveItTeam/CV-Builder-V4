import Foundation

enum TabFlow: Int, CaseIterable {
    case home = 0, templates, works, profile

    var id: Int {
        return self.rawValue
    }
  
    var active: ImageResource {
        switch self {
        case .home:
            return .woman
        case .templates:
            return .woman
        case .works:
            return .woman
        case .profile:
            return .woman
        }
    }

    var localizedTitle: String {
        switch self {
        case .home:
            return ""
        case .templates:
            return ""
        case .works:
            return ""
        case .profile:
            return ""
        }
    }
}
