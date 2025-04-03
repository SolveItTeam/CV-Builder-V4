import SwiftUI

struct PopularTemplatesView: View {
    @StateObject var viewModel: PopularTemplatesViewModel
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]
    
    var body: some View {
        VStack {
            
            if viewModel.isFromPush {
                BackButtonBar(showProIcon: $viewModel.showProIcon) {
                    viewModel.backTapped()
                } action: {
                    viewModel.showPaywall()
                }
                .padding(.horizontal, 16)
            } else {
                NavBar(showProIcon: $viewModel.showProIcon) {
                    viewModel.showPaywall()
                }
                .padding(.horizontal, 16)
            }
            
            
            ScrollView {
                HStack {
                    Text(viewModel.isFromPush ? R.string.localizable.popularTemplates : R.string.localizable.templates)
                        .font(Font(R.font.figtreeRegular(size: 30)!))
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                .padding(.horizontal, 16)
                
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(Array(templatesList.enumerated()), id: \.element) { index, template in
                        Button(action: {
                            viewModel.showPreview(cvtemplate: template)
                        }) {
                            Image(template.templatePreview)
                                .resizable()
                                .scaledToFit()
                                .overlay(alignment: .topTrailing ) {
                                    if viewModel.showProIcon {
                                        Image(.crown)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 24, height: 16)
                                            .padding(10)
                                    }
                                }
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
                .padding(.horizontal, 16)
                
                Spacer(minLength: 100)
            }
        }
    }
}

#Preview {
    PopularTemplatesView(viewModel: .init(coordinator: .init(), isFromPush: false))
}
