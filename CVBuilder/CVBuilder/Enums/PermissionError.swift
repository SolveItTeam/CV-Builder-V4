import Foundation

enum PermissionError: Error {
    case cameraAccessDenied
    case photoLibraryAccessDenied
    case photoCaptureFailed
    
    var message: String {
        switch self {
        case .cameraAccessDenied:
            return "Camera Granted Access Denied"
        case .photoLibraryAccessDenied:
            return "Photo Library Granted Access Denied"
        case .photoCaptureFailed:
            return "photoCaptureFailed"
        }
    }
}
