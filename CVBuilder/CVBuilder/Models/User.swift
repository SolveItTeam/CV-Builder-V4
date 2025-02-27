import Foundation

struct User: Observable, Equatable, Codable {
    let id: String
    var isPremium: Bool
}
