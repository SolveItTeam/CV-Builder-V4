import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    var body: some View {
        VStack {
            HStack {
                Text(R.string.localizable.)
            }
        }
    }
}

#Preview {
    HomeView(viewModel: .init(coordinator: .init()))
}
