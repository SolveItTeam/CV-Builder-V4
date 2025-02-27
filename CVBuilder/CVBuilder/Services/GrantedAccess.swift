import PhotosUI
import AVFoundation

final class GrantedAccess {
//    func requestCameraAccess(completion: @escaping (Error?) -> Void) {
//        switch AVCaptureDevice.authorizationStatus(for: .video) {
//        case .notDetermined:
//            AVCaptureDevice.requestAccess(for: .video) { granted in
//                DispatchQueue.main.async {
//                    completion(granted ? nil : PermissionError.cameraAccessDenied)
//                }
//            }
//        case .authorized:
//            completion(nil)
//        default:
//            completion(PermissionError.cameraAccessDenied)
//        }
//    }
//    
    func requestPhotoLibraryAccess() async throws {
        try await withCheckedThrowingContinuation { continuation in
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized, .limited:
                    continuation.resume(returning: ())
                case .denied, .restricted, .notDetermined:
                    let error = NSError(domain: "AuthorizationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Photo library access denied"])
                    continuation.resume(throwing: error)
                default:
                    let error = NSError(domain: "AuthorizationError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unknown authorization status"])
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
