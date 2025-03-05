import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    var body: some View {
        VStack {
            Text("sett")
        }
    }
}

#Preview {
    SettingsView(viewModel: .init(coordinator: .init()))
}
