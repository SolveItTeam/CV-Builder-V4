
import SwiftUI

struct AngledNotchCardShape: Shape {
    let cornerRadius: CGFloat
    
    let topAngleInset: CGFloat
    
    let topAngleHeight: CGFloat
    
    let centerWidth: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let totalTopWidth = rect.width - 2 * (cornerRadius + topAngleInset)
        let angledSegmentWidth = (totalTopWidth - centerWidth) / 2
        path.move(to: CGPoint(x: 0, y: cornerRadius))
        path.addQuadCurve(
            to: CGPoint(x: cornerRadius, y: 0),
            control: CGPoint(x: 0, y: 0)
        )
        
        let leftInsetEndX = cornerRadius + topAngleInset
        path.addLine(to: CGPoint(x: leftInsetEndX + 80, y: 0))
        
        let leftAngleEndX = leftInsetEndX + angledSegmentWidth
        path.addLine(to: CGPoint(x: leftAngleEndX, y: topAngleHeight))
        
        path.addLine(to: CGPoint(x: leftAngleEndX + centerWidth, y: topAngleHeight))
        
        let rightAngleStartX = leftAngleEndX + centerWidth
        let rightInsetStartX = rightAngleStartX + angledSegmentWidth
        path.addLine(to: CGPoint(x: rightInsetStartX - 80, y: 0))
        
        let topRightArcStartX = rect.width - cornerRadius
        path.addLine(to: CGPoint(x: topRightArcStartX, y: 0))
        path.addQuadCurve(
            to: CGPoint(x: rect.width, y: cornerRadius),
            control: CGPoint(x: rect.width, y: 0)
        )
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - cornerRadius))
        path.addQuadCurve(
            to: CGPoint(x: rect.width - cornerRadius, y: rect.height),
            control: CGPoint(x: rect.width, y: rect.height)
        )
        
        path.addLine(to: CGPoint(x: cornerRadius, y: rect.height))
        path.addQuadCurve(
            to: CGPoint(x: 0, y: rect.height - cornerRadius),
            control: CGPoint(x: 0, y: rect.height)
        )
        
        path.closeSubpath()
        return path
    }
}
