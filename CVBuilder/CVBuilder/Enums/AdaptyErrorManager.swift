import Foundation
import Adapty

struct AdaptyErrorManager {
    var log: LocalizedStringResource = ""
    var adaptyErrorCode: AdaptyError.ErrorCode = .unknown
    
    init(error: Error) {
        let textError = getLog(error: error)
        self.log = textError
        self.adaptyErrorCode = errorCode(error: error)
    }
    
    private func errorCode(error: Error) -> AdaptyError.ErrorCode {
        guard let adaptyError = error as? AdaptyError else {
            return .unknown
        }
        return adaptyError.adaptyErrorCode
    }
    
    private func getLog(error: Error) -> LocalizedStringResource {
        guard let adaptyError = error as? AdaptyError else {
            return LocalizedStringResource(stringLiteral: error.localizedDescription)
        }
        
        switch adaptyError.adaptyErrorCode {
        case .unknown:
            return LocalizedStringResource(stringLiteral: "Unknown Error")
        case .clientInvalid:
            return LocalizedStringResource(stringLiteral: "Client Invalid")
        case .paymentCancelled:
            return LocalizedStringResource(stringLiteral: "Payment Cancelled")
        case .paymentInvalid:
            return LocalizedStringResource(stringLiteral: "One of the payment details was not recognized.")
        case .paymentNotAllowed:
            return LocalizedStringResource(stringLiteral: "You are not authorized to make payments.")
        case .storeProductNotAvailable:
            return LocalizedStringResource(stringLiteral: "The requested item is not available in the store.")
        case .cloudServicePermissionDenied:
            return LocalizedStringResource(stringLiteral: "Access to Cloud service information is denied.")
        case .cloudServiceNetworkConnectionFailed:
            return LocalizedStringResource(stringLiteral: "Unable to connect to the network.")
        case .cloudServiceRevoked:
            return LocalizedStringResource(stringLiteral: "Permission to use the cloud service has been revoked.")
        case .privacyAcknowledgementRequired:
            return LocalizedStringResource(stringLiteral: "You need to acknowledge Apple's privacy policy for Apple Music.")
        case .unauthorizedRequestData:
            return LocalizedStringResource(stringLiteral: "The app is attempting to use unauthorized data.")
        case .invalidOfferIdentifier:
            return LocalizedStringResource(stringLiteral: "The offer identifier is invalid.")
        case .invalidSignature:
            return LocalizedStringResource(stringLiteral: "The payment discount signature is invalid.")
        case .missingOfferParams:
            return LocalizedStringResource(stringLiteral: "Some parameters are missing in the payment discount.")
        case .invalidOfferPrice:
            return LocalizedStringResource(stringLiteral: "The price specified in App Store Connect is no longer valid.")
        case .noProductIDsFound:
            return LocalizedStringResource(stringLiteral: "No In-App Purchase product identifiers were found.")
        case .productRequestFailed:
            return LocalizedStringResource(stringLiteral: "Unable to fetch available In-App Purchase products at the moment.")
        case .cantMakePayments:
            return LocalizedStringResource(stringLiteral: "In-App Purchases are not allowed on this device.")
        case .cantReadReceipt:
            return LocalizedStringResource(stringLiteral: "Cannot find a valid receipt.")
        case .productPurchaseFailed:
            return LocalizedStringResource(stringLiteral: "Product purchase failed.")
        case .refreshReceiptFailed:
            return LocalizedStringResource(stringLiteral: "Failed to refresh receipt.")
        case .notActivated:
            return LocalizedStringResource(stringLiteral: "You need to be authenticated to perform requests.")
        case .badRequest:
            return LocalizedStringResource(stringLiteral: "The request made is not valid.")
        case .serverError:
            return LocalizedStringResource(stringLiteral: "There was an error on the server side.")
        case .networkFailed:
            return LocalizedStringResource(stringLiteral: "Failed to complete the network request.")
        case .decodingFailed:
            return LocalizedStringResource(stringLiteral: "Unable to decode the response.")
        case .encodingFailed:
            return LocalizedStringResource(stringLiteral: "Failed to encode parameters for the request.")
        case .analyticsDisabled:
            return LocalizedStringResource(stringLiteral: "Analytics events cannot be handled because you have opted out.")
        case .wrongParam:
            return LocalizedStringResource(stringLiteral: "An incorrect parameter was passed.")
        case .activateOnceError:
            return LocalizedStringResource(stringLiteral: "Activate once error.")
        case .profileWasChanged:
            return LocalizedStringResource(stringLiteral: "The user profile was changed during the operation.")
        case .unsupportedData:
            return LocalizedStringResource(stringLiteral: "Data is unsupported.")
        case .fetchTimeoutError:
            return LocalizedStringResource(stringLiteral: "The request timed out.")
        case .operationInterrupted:
            return LocalizedStringResource(stringLiteral: "The operation was interrupted by the system.")
        case .fetchSubscriptionStatusFailed:
            return LocalizedStringResource(stringLiteral: "The request timed out.")
        }
    }
}
