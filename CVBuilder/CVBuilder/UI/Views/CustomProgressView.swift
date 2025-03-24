

import SwiftUI

struct CustomProgressView: View {
    @Binding var isShown: Bool
    
    var body: some View {
        if isShown {
            VStack {
                Spacer()
                ProgressView()
                    .scaleEffect(1.7)
                    .frame(width: 75, height: 75)
                    .background(Color.cE1FF41)
                    .tint(.blackMain)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                Spacer()
            }
            .ignoresSafeArea(.all)
        }
    }
}
