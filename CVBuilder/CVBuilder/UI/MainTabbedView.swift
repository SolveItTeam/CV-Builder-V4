import SwiftUI

struct MainTabbedView: View {
    
    @State var selectedTab = 0
    let coordinator: Coordinator
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView(viewModel: .init(coordinator: coordinator))
                    .tag(TabFlow.home.rawValue)

                PopularTemplatesView(viewModel: .init(coordinator: coordinator, isFromPush: false))
                    .tag(TabFlow.plus.rawValue)
                
                CoverLetterView(viewModel: .init(coordinator: coordinator, isFromPush: false))
                    .tag(TabFlow.history.rawValue)
                
                SettingsView(viewModel: .init(coordinator: coordinator))
                    .tag(TabFlow.settings.rawValue)
            }
            .tint(.white)
            
            VStack {
                ZStack{
                    HStack{
                        ForEach((TabFlow.allCases), id: \.self) { item in
                            Button{
                                selectedTab = item.rawValue
//                                
//                                switch selectedTab {
//                                case 1:
//                                    coordinator.showProfileView()
//                                    selectedTab = TabFlow.home.rawValue
//                                default:
//                                    break
//                                }
                               
                            } label: {
                                CustomTabItem(imageName: item.active, isActive: (selectedTab == item.rawValue), isPlusTab: item.rawValue == TabFlow.plus.rawValue)
                            }
                        }
                    }
                    .padding(6)
                }
                .background(.c393939)
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .padding(.horizontal, 26)

            }
            .background(.c0A0A0A)
        }
    }
}

extension MainTabbedView{
    func CustomTabItem(imageName: ImageResource, isActive: Bool, isPlusTab: Bool) -> some View{
        HStack(spacing: 4){
            Spacer()
            
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isPlusTab ? .c0A0A0A : .white)
                .frame(width: isPlusTab ? 14 : 20, height: isPlusTab ? 14 : 20)
        
            Spacer()
        }
        .frame(width: 65, height: 65)
        .background(isPlusTab ? .cE1FF41 : isActive ? .cA1A1A1 : .c686868.opacity(0.3))
        .clipShape(Circle())
    }
}

#Preview {
    MainTabbedView(coordinator: .init())
}
