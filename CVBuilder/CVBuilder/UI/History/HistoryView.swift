import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel
    var body: some View {
        VStack {
            Text("HistoryView")
        }
    }
}

#Preview {
    HistoryView(viewModel: .init(coordinator: .init()))
}
