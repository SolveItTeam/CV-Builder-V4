import Foundation
import Adapty

struct AdaptyErrorManager {
    var log: String = ""
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
    
    private func getLog(error: Error) -> String {
        guard let adaptyError = error as? AdaptyError else {
            return  error.localizedDescription
        }
        
        switch adaptyError.adaptyErrorCode {
        case .unknown:
            return R.string.localizable.unknown_error()
        case .clientInvalid:
            return R.string.localizable.client_invalid()
        case .paymentCancelled:
            return R.string.localizable.payment_cancelled()
        case .paymentInvalid:
            return R.string.localizable.payment_invalid()
        case .paymentNotAllowed:
            return R.string.localizable.payment_not_allowed()
        case .storeProductNotAvailable:
            return R.string.localizable.store_product_not_available()
        case .cloudServicePermissionDenied:
            return R.string.localizable.cloud_service_permission_denied()
        case .cloudServiceNetworkConnectionFailed:
            return R.string.localizable.cloud_service_network_failed()
        case .cloudServiceRevoked:
            return R.string.localizable.cloud_service_revoked()
        case .privacyAcknowledgementRequired:
            return R.string.localizable.privacy_acknowledgement_required()
        case .unauthorizedRequestData:
            return R.string.localizable.unauthorized_request_data()
        case .invalidOfferIdentifier:
            return R.string.localizable.invalid_offer_identifier()
        case .invalidSignature:
            return R.string.localizable.invalid_signature()
        case .missingOfferParams:
            return R.string.localizable.missing_offer_params()
        case .invalidOfferPrice:
            return R.string.localizable.invalid_offer_price()
        case .noProductIDsFound:
            return R.string.localizable.no_product_ids_found()
        case .productRequestFailed:
            return R.string.localizable.product_request_failed()
        case .cantMakePayments:
            return R.string.localizable.cant_make_payments()
        case .cantReadReceipt:
            return R.string.localizable.cant_read_receipt()
        case .productPurchaseFailed:
            return R.string.localizable.product_purchase_failed()
        case .refreshReceiptFailed:
            return R.string.localizable.refresh_receipt_failed()
        case .notActivated:
            return R.string.localizable.not_activated()
        case .badRequest:
            return R.string.localizable.bad_request()
        case .serverError:
            return R.string.localizable.server_error()
        case .networkFailed:
            return R.string.localizable.network_failed()
        case .decodingFailed:
            return R.string.localizable.decoding_failed()
        case .encodingFailed:
            return R.string.localizable.encoding_failed()
        case .analyticsDisabled:
            return R.string.localizable.analytics_disabled()
        case .wrongParam:
            return R.string.localizable.wrong_param()
        case .activateOnceError:
            return R.string.localizable.activate_once_error()
        case .profileWasChanged:
            return R.string.localizable.profile_was_changed()
        case .unsupportedData:
            return R.string.localizable.unsupported_data()
        case .fetchTimeoutError:
            return R.string.localizable.fetch_timeout_error()
        case .operationInterrupted:
            return R.string.localizable.operation_interrupted()
        case .fetchSubscriptionStatusFailed:
            return R.string.localizable.fetch_timeout_error()
        }
    }
}
