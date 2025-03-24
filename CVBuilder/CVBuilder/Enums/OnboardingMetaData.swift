import SwiftUI

enum OnboardingMetaData: CaseIterable {
    case page1
    case page2
    case page3
    case page4
    case page5
    
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
        case .page5:
            return .woman
        }
    }
    
    

    var title: String {
        switch self {
        case .page1:
            return R.string.localizable.createThePerfectResumeInMinutes()
        case .page2:
            return R.string.localizable.supportOurGrowthRateUs()
        case .page3:
            return R.string.localizable.createYourResumeFaster()
        case .page4:
            return R.string.localizable.aSetOfDocumentsForWork()
        case .page5:
            return R.string.localizable.premiumIsYourWayToThePerfectResume()
        }
    }
    


    var subtitle: String {
        switch self {
        case .page1:
            return R.string.localizable.createAResumeThatWorksForYouProfessionalLogicalAndStylish()
        case .page2:
            return R.string.localizable.expressYourAppreciationByLeavingAReviewOnTheAppStore()
        case .page3:
            return R.string.localizable.yourInformationIsSavedAndAutomaticallyTransferredToTheNewTemplate()
        case .page4:
            return R.string.localizable.addACoverLetterAndGetACompleteSetForJobSearch()
        
        case .page5:
            return R.string.localizable.startToContinueAppWith3DaysTrialWeek("")
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
        case .page5:
            return 4
        }
    }
}
