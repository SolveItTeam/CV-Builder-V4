import Foundation

struct User: Observable, Codable {
    let id: String
    var isPremium: Bool
    var savedData: CVConstructor
}
