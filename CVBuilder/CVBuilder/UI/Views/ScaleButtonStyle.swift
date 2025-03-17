import SwiftUI

struct ScaleButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}

struct CircularButton: ButtonStyle {
    var width: CGFloat = 60
    var height: CGFloat = 60
    let opacity: CGFloat
    let color: Color
    
    init(opacity: CGFloat = 1, color: Color = .c393939) {
        self.opacity = opacity
        self.color = color
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(width: width, height: height)
            .background(color.opacity(opacity))
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}
