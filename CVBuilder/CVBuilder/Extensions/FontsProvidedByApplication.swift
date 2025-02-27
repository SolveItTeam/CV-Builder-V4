import Foundation

enum FontsProvidedByApplication: String {
    case montserrat = "Montserrat-"
    case poppins = "Poppins-"
}

enum FontsWeight: String {
    case semibold = "SemiBold"
    case regular = "Regular"
    case bold = "Bold"
    case medium = "Medium"
}



import SwiftUI

extension Font {
    static func montserrat(
        style: FontsWeight,
        size: CGFloat,
        relativeTo textStyle: Font.TextStyle = .body) -> Font {
            let fontName: String = FontsProvidedByApplication.montserrat.rawValue + style.rawValue
            return Font.custom(fontName, size: size, relativeTo: textStyle)
        }
    
    static func poppins(
        style: FontsWeight,
        size: CGFloat,
        relativeTo textStyle: Font.TextStyle = .body) -> Font {
            let fontName: String = FontsProvidedByApplication.poppins.rawValue + style.rawValue
            return Font.custom(fontName, size: size, relativeTo: textStyle)
        }
}
