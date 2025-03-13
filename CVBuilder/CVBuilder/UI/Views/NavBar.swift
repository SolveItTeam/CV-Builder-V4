import SwiftUI

struct NavBar: View {
    let action: () -> Void
    
    var body: some View {
        HStack {
            Text(R.string.localizable.cvBuilder)
                .font(Font(R.font.figtreeRegular.callAsFunction(size: 20)!))
                .foregroundStyle(.white)
            
            Spacer()
            
            Button {
                action()
            } label: {
                HStack(spacing: 4) {
                    Image(.pro)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 16)
                    
                    Text(R.string.localizable.prO)
                        .font(Font(R.font.figtreeSemiBold.callAsFunction(size: 20)!))
                        .foregroundStyle(.white)
                }
                .padding(10)
                .background(.c3200E0)
                .clipShape(RoundedRectangle(cornerRadius: 32))
            }
        }
    }
}

struct BackButtonBar: View {
    let backAction: () -> Void
    let action: () -> Void
    
    var body: some View {
        HStack {
            Button {
                backAction()
            } label: {
                Image(.left)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 16, height: 16)
            }
            .buttonStyle(CircularButton())
            
            Spacer()
            
            Button {
                action()
            } label: {
                HStack(spacing: 4) {
                    Image(.pro)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 16)
                    
                    Text(R.string.localizable.prO)
                        .font(Font(R.font.figtreeSemiBold.callAsFunction(size: 20)!))
                        .foregroundStyle(.white)
                }
                .padding(10)
                .background(.c3200E0)
                .clipShape(RoundedRectangle(cornerRadius: 32))
            }
        }
    }
}

#Preview {
    HomeView(viewModel: .init(coordinator: .init()))
}
