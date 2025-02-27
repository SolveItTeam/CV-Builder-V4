import SwiftUI

enum OnboardingMetaData: CaseIterable {
    case page1
    case page2
    case page3
    case page4
    
    var image: ImageResource {
        switch self {
        case .page1:
            return .woman
        case .page2:
            return .woman
        case .page3:
            return .woman
        case .page4:
            return .woman
        }
    }
    
    

    var title: String {
        switch self {
        case .page1:
            return ""
        case .page2:
            return ""
        case .page3:
            return ""
        case .page4:
            return ""
        }
    }
    


    var subtitle: String {
        switch self {
        case .page1:
            return ""
        case .page2:
            return ""
        case .page3:
            return ""
        case .page4:
            return ""
        
        }
    }
    
    var num: Int {
        switch self {
        case .page1:
            return 0
        case .page2:
            return 1
        case .page3:
            return 2
        case .page4:
            return 3
        }
    }
}
