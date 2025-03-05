import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    var body: some View {
        VStack {
            Text("ProfileView")
        }
    }
}

#Preview {
    ProfileView(viewModel: .init(coordinator: .init()))
}
