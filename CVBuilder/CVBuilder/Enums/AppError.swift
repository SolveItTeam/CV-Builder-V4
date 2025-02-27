import Foundation

enum AppError: Error, LocalizedError {
    case raw(title: String, subTitle: String)

    var errorDescription: String? {
        switch self {
        case .raw(let title, let subTitle):
            return "\(title): \(subTitle)"
        }
    }

    var title: String {
        switch self {
        case .raw(let title, _):
            return title
        }
    }

    var subTitle: String {
        switch self {
        case .raw(_, let subTitle):
            return subTitle
        }
    }
}
