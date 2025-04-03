import SwiftUI

struct CustomProgressView: View {
    @Binding var isShown: Bool
    
    var body: some View {
        if isShown {
            ZStack {
                Color.black.opacity(0.01).ignoresSafeArea()
                ProgressView()
                    .scaleEffect(1.7)
                    .frame(width: 75, height: 75)
                    .background(Color.cE1FF41)
                    .tint(.blackMain)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
     
            }
        }
    }
}
