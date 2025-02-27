import SwiftUI
import MessageUI


final class PaymentRefunder: NSObject, MFMailComposeViewControllerDelegate {
    static let shared = PaymentRefunder()
    
    var closeAction: (() -> Void)?
    
    private override init() { }
    
    func present(
        errorTitle: String,
        errorMessage: String,
        supportEmail: String,
        subject: String? = "E Signature",
        body: String? = nil
    ) {
        DispatchQueue.main.async {
            if !MFMailComposeViewController.canSendMail() {
                self.presentAlert(
                    title: errorTitle,
                    message: errorMessage,
                    primaryAction: .ok {}
                )
                return
            }
            
            let picker = MFMailComposeViewController()
            picker.setToRecipients([supportEmail])
            picker.setSubject(subject ?? "E Signature")
            
            var emailBody = body ?? "Please describe your issue here."
            emailBody += "\n\n---\nApp Version: \(self.getAppVersion())\nDevice: \(self.getDeviceInfo())"
            picker.setMessageBody(emailBody, isHTML: false)
            
            picker.mailComposeDelegate = self
            UIApplication.shared.lastVC?.present(picker, animated: true)
        }
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    
    func mailComposeController(
        _ controller: MFMailComposeViewController,
        didFinishWith result: MFMailComposeResult,
        error: Error?
    ) {
        controller.dismiss(animated: true) {
            switch result {
            case .sent:
                self.presentAlert(
                    title: "Thank You",
                    message: "Your support request has been sent successfully.",
                    primaryAction: .ok()
                )
            case .failed:
                self.presentAlert(
                    title: "Error",
                    message: "Failed to send email. Please try again later.",
                    primaryAction: .retry { [weak self] in
                        self?.present(
                            errorTitle: "Error",
                            errorMessage: "Failed to send email. Please try again.",
                            supportEmail: ConfigValues.getValue().email
                        )
                    },
                    secondaryAction: .cancel()
                )
            default:
                break
            }
            self.closeAction?()
        }
    }
    
    // MARK: - Helper Methods
    
    private func presentAlert(
        title: String,
        message: String,
        primaryAction: UIAlertAction,
        secondaryAction: UIAlertAction? = nil,
        tertiaryAction: UIAlertAction? = nil
    ) {
        guard let topVC = UIApplication.shared.lastVC else { return }
            
            let alert = UIAlertController(
                title: title,
                message: message,
                preferredStyle: .alert
            )
            
            alert.addAction(primaryAction)
            if let secondary = secondaryAction { alert.addAction(secondary) }
            if let tertiary = tertiaryAction { alert.addAction(tertiary) }
            topVC.present(alert, animated: true)

    }
    
    private func getAppVersion() -> String {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "N/A"
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "N/A"
        return "\(version) (\(build))"
    }
    
    private func getDeviceInfo() -> String {
        let device = UIDevice.current
        return "\(device.model) running iOS \(device.systemVersion)"
    }
}

// MARK: - UIAlertAction Extensions

extension UIAlertAction {
    static func cancel(handler: (() -> Void)? = nil) -> UIAlertAction {
        UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel) { _ in
            handler?()
        }
    }
    
    static func ok(handler: (() -> Void)? = nil) -> UIAlertAction {
        UIAlertAction(title: NSLocalizedString("OK", comment: ""), style: .default) { _ in
            handler?()
        }
    }
    
    static func retry(handler: (() -> Void)? = nil) -> UIAlertAction {
        UIAlertAction(title: NSLocalizedString("Retry", comment: ""), style: .default) { _ in
            handler?()
        }
    }
}
