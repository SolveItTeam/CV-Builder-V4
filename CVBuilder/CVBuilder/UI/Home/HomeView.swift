import SwiftUI

struct HomeView: View {
    @ObservedObject var viewModel: HomeViewModel
    var body: some View {
        VStack {
            NavBar(showProIcon: $viewModel.showProIcon) {
                viewModel.showPaywall()
            }
            
            ScrollView(showsIndicators: false) {
                HStack {
                    Text(R.string.localizable.popularTemplates)
                        .font(Font(R.font.figtreeRegular.callAsFunction(size: 30)!))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Button {
                        viewModel.showResumeTemplates()
                    } label: {
                        Image(.right)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                    }
                    .buttonStyle(CircularButton())
                    
                }
                .padding(.top, 10)
                
                HStack(spacing: 16) {
                    Button {
                      
                    } label: {
                        Image(.popularTemplates1)
                            .resizable()
                            .scaledToFit()
                    }
                    
                    Button {
                        
                    } label: {
                        Image(.popularTemplates2)
                            .resizable()
                            .scaledToFit()
                        
                    }
                }
                
                HStack {
                    Text(R.string.localizable.myResumes)
                        .font(Font(R.font.figtreeRegular.callAsFunction(size: 30)!))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Button {
                        
                    } label: {
                        Image(.right)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                    }
                    .buttonStyle(CircularButton())
                    
                }
                .padding(.top, 10)
                
                 
                if true {
                    VStack(spacing: 0) {
                        Circle().fill(.c393939.opacity(0.6))
                            .frame(width: 120, height: 120)
                            .overlay {
                                Image(.noHistory)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 78.33)
                            }
                        
                        Text(R.string.localizable.itSEmptyHereYet)
                            .font(Font(R.font.figtreeRegular.callAsFunction(size: 20)!))
                            .padding(.top, 16)
                        
                        Text(R.string.localizable.cxde)
                            .font(Font(R.font.figtreeRegular.callAsFunction(size: 16)!))
                            .foregroundStyle(.cA1A1A1)
                            .padding(.top, 8)
                    }
                } else {
                    //ForEach
                }
                
                Spacer(minLength: 100)
            }
        }
        .padding(.horizontal, 16)
    }
}

#Preview {
    MainTabbedView(coordinator: .init())
}
