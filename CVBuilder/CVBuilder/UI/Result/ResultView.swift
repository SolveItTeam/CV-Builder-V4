import SwiftUI
import ShuffleIt

struct ResultView: View {
    @StateObject var viewModel: ResultViewModel
  
    var body: some View {
        VStack {
            HStack {
                Button {
                    viewModel.backTapped()
                } label: {
                    Image(.left)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                }
                .buttonStyle(CircularButton())
                
                Spacer()
                 
                HStack(spacing: 8) {
                    Button {
                        
                    } label: {
                        Image(.shareapp)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 24, height: 24)
                    }
                    .buttonStyle(CircularButton())
                    
                    Button {
                        
                    } label: {
                        Image(.cross)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 10, height: 10)
                        
                    }
                    .buttonStyle(CircularButton())
                }
            }
            .padding(.horizontal, 16)
            
            ScrollView {
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
                .padding(.top, 10)
                
                TemplateDots(pageCount: templatesList.count, currentIndex: $viewModel.currentIndex)
            }
            
            VStack(spacing: 16) {
                Button {
                    
                } label: {
                    Text(R.string.localizable.edit())
                        .font(Font(R.font.figtreeSemiBold.callAsFunction(size: 20)!))
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(.blackMain)
                        .clipShape(RoundedRectangle(cornerRadius: 32))
                        .overlay {
                            RoundedRectangle(cornerRadius: 32)
                                .stroke(.cE1FF41, lineWidth: 1)
                        }
                        .contentShape(Rectangle())
                }

                .buttonStyle(ScaleButtonStyle())
                
                
                Button {
                    
                } label: {
                    Text(R.string.localizable.download())
                        .font(Font(R.font.figtreeSemiBold.callAsFunction(size: 20)!))
                        .foregroundStyle(.blackMain)
                        .frame(maxWidth: .infinity)
                        .frame(height: 60)
                        .background(.cE1FF41)
                        .clipShape(RoundedRectangle(cornerRadius: 32))
                        .contentShape(Rectangle())
                }

                .buttonStyle(ScaleButtonStyle())
                

            }
            .padding(.bottom, 8)
            .padding(.horizontal, 16)
        }
    }
}
 

#Preview {
    ResultView(viewModel: .init(coordinator: .init(), chosenTemplate: .init(templatePreview: .template1, fileToUseString: "template1.pdf")) )
}


