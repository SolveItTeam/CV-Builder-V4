import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    var body: some View {
        VStack {
            NavBar(showProIcon: $viewModel.showProIcon) {
                viewModel.showPaywall()
            }
            .padding(.horizontal, 16)
            
            ScrollView(showsIndicators: false) {
                HStack {
                    Text(R.string.localizable.settings)
                        .font(Font(R.font.figtreeRegular.callAsFunction(size: 30)!))
                    Spacer()
                }
                
                VStack(spacing: 8) {
                    ForEach(SettingsItem.allCases, id: \.self) { item in
                        SettingsCellView(icon: item.icon, title: item.title) {
                            viewModel.itemTapped(item)
                        }
                    }
                }
                .padding(.top, 4)
            }
            .padding(.horizontal, 16)
            .padding(.top, 14)
        }
        .alert(isPresented: $viewModel.isShowingAlert) {
            Alert(
                title: Text(viewModel.errorMessage.title),
                message: Text(viewModel.errorMessage.subTitle),
                dismissButton: .default(
                    Text(R.string.localizable.okTitle)
                ) {}
            )
        }
    }
}

#Preview {
    SettingsView(viewModel: .init(coordinator: .init()))
}


import SwiftUI

struct SettingsCellView: View {

    let icon: ImageResource
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack {
                Circle()
                    .fill(.c686868)
                    .frame(width: 60, height: 60)
                    .overlay {
                        Image(icon)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                
                Text(title)
                    .font(Font(R.font.figtreeRegular.callAsFunction(size: 20)!))
                    .foregroundStyle(.white)
                    .padding(.leading, 2)
                
                Spacer()
                 
            }
            .padding(.vertical, 6)
            .padding(.horizontal, 6)
            .background(.c393939)
            .clipShape(RoundedRectangle(cornerRadius: 60))
        }
        .buttonStyle(ScaleButtonStyle())
    }
}
