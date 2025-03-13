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
    
    init(opacity: CGFloat = 1) {
        self.opacity = opacity
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label

            .frame(width: width, height: height)
            .background(.c393939.opacity(opacity))
            .clipShape(Circle())
            .scaleEffect(configuration.isPressed ? 0.85 : 1.0)
            .animation(.easeInOut, value: configuration.isPressed)
    }
}
