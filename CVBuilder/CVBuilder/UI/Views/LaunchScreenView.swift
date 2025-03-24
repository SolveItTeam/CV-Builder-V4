
import SwiftUI

struct LaunchScreenView: View {
    
    var body: some View {
        ZStack {

                    
                    Image(.launch)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 110, height: 110)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
         
        }
    }
}

#Preview {
    LaunchScreenView()
}
