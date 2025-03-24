import SwiftUI
import ShuffleIt

struct TemplatePreviewView: View {
    @StateObject var viewModel: TemplatePreviewViewModel
 
    
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
                    Text(R.string.localizable.templatePreview)
                        .font(Font(R.font.figtreeRegular(size: 30)!))
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                .padding(.top, 10)
                .padding(.horizontal, 16)
                CarouselStack(
                    templatesList,
                    initialIndex: templatesList.firstIndex(where: { viewModel.chosenTemplate.fileToUseString == $0.fileToUseString })
                ) { template in
                    Image(template.templatePreview)
                        .resizable()
                        .scaledToFit()
                        .frame(height: 457)
                        .cornerRadius(16)
                }
                .carouselScale(0.8)
                .carouselStyle(.infiniteScroll)
                .onCarousel { new in
                    viewModel.chosenTemplate = templatesList[new.index]
                    viewModel.currentIndex = new.index
                }
                
                TemplateDots(pageCount: templatesList.count, currentIndex: $viewModel.currentIndex)
            }
            
            Button {
                
            } label: {
                    Text(R.string.localizable.create())
                        .font(Font(R.font.figtreeSemiBold.callAsFunction(size: 20)!))
                        .foregroundStyle(.blackMain)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(.cE1FF41)
                        .clipShape(RoundedRectangle(cornerRadius: 32))
                        .contentShape(Rectangle())
            }

            .buttonStyle(ScaleButtonStyle())
        
        .padding(.bottom, 8)
        .padding(.horizontal, 16)
        }
    }
}
 

#Preview {
    TemplatePreviewView(viewModel: .init(coordinator: .init(), chosenTemplate: .init(templatePreview: .template1, fileToUseString: "template1.pdf")) )
}


