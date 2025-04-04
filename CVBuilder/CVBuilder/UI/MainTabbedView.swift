import SwiftUI

struct MainTabbedView: View {
    
    @State var selectedTab = 0
    let coordinator: Coordinator
    @State var homeView: HomeView
    @State var templatesView: PopularTemplatesView
    @State var coverLetterView: CoverLetterView
    @State var settingsView: SettingsView
    
    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                HomeView(viewModel: .init(coordinator: coordinator))
                    .tag(TabFlow.home.rawValue)
                    .tabItem {
                        Image(.shareapp)
                    }
                PopularTemplatesView(viewModel: .init(coordinator: coordinator, isFromPush: false))
                    .tag(TabFlow.plus.rawValue)
                    .tabItem {
                        Image(.shareapp)
                    }
                CoverLetterView(viewModel: .init(coordinator: coordinator))
                    .tag(TabFlow.history.rawValue)
                    .tabItem {
                        Image(.shareapp)
                    }
                SettingsView(viewModel: .init(coordinator: coordinator))
                    .tag(TabFlow.settings.rawValue)
                    .tabItem {
                        Image(.shareapp)
                    }
            }
            .tint(.white)
            
            VStack {
                ZStack{
                    HStack(spacing: 2) {
                        ForEach((TabFlow.allCases), id: \.self) { item in
                            Button{
                                selectedTab = item.rawValue
                                
                                switch selectedTab {
                                case 1:
                                    coordinator.showProfileView()
                                    selectedTab = TabFlow.home.rawValue
                                default:
                                    break
                                }
                               
                            } label: {
                                CustomTabItem(imageName: item.active, isActive: (selectedTab == item.rawValue), isPlusTab: item.rawValue == TabFlow.plus.rawValue)
                            }
                        }
                    }
                    .padding(.vertical, 6)
                    .padding(.horizontal, 2)
                    
                }
                .frame(width: 343)
                .background(.c393939)
                .clipShape(RoundedRectangle(cornerRadius: 40))
                .padding(.horizontal, 30)
            }
            .frame(maxWidth: .infinity)
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
