
import Foundation

struct Product: Identifiable, Equatable {
    let id: UUID
    let vendorProductId: String
    let localizedPrice: String
    let localizedTitle: String
    let localizedDescription: String
}

struct ProductTitle {
    static let weeklyProductTitle = "Weekly"
    static let monthlyProductTitle = "Monthly"
    static let yearlyProductTitle = "Yearly"
}
