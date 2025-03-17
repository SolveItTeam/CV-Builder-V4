import SwiftUI


struct CustomColorToggleStyle: ToggleStyle {

    var activeColor: Color = .cA1A1A1

    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label

            Spacer()

            RoundedRectangle(cornerRadius: 30)
                .fill(configuration.isOn ? activeColor : activeColor.opacity(0.9))
                .overlay {
                    Circle()
                        .fill(configuration.isOn ? .cE1FF41 : .white)
                        .frame(width: 24, height: 24)
                        .offset(x: configuration.isOn ? 12 : -12)

                }
                .frame(width: 54, height: 28)
                .onTapGesture {
                    withAnimation(.spring()) {
                        configuration.isOn.toggle()
                    }
                }
        }
    }
}
