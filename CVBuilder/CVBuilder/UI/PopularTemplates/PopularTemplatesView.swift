import SwiftUI

struct PopularTemplatesView: View {
    @StateObject var viewModel: PopularTemplatesViewModel
    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16),
    ]
    
    var body: some View {
        VStack {
            BackButtonBar(showProIcon: $viewModel.showProIcon) {
                viewModel.backTapped()
            } action: {
                viewModel.showPaywall()
            }
            .padding(.horizontal, 16)
            
            
            ScrollView {
                HStack {
                    Text(R.string.localizable.popularTemplates)
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
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 16))
                        .buttonStyle(ScaleButtonStyle())
                    }
                }
                .padding(.horizontal, 16)
            }
        }
    }
}

#Preview {
    PopularTemplatesView(viewModel: .init(coordinator: .init()))
}
