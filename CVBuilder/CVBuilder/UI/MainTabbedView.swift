import SwiftUI


struct MainTabbedView: View {
    
    @State var selectedTab = 0
    let coordinator: Coordinator
    
    var body: some View {
        
        ZStack(alignment: .bottom){
            TabView(selection: $selectedTab) {
             
            }

            ZStack{
                HStack{
                    ForEach((TabFlow.allCases), id: \.self){ item in
                        Button{
                            selectedTab = item.rawValue
                        } label: {
                            CustomTabItem(imageName: item.active, title: item.localizedTitle, isActive: (selectedTab == item.rawValue))
                        }
                    }
                }
                .padding(6)
            }
            .frame(height: 70)
            .background(.purple.opacity(0.2))
            .cornerRadius(35)
            .padding(.horizontal, 26)
        }
    }
}

extension MainTabbedView{
    func CustomTabItem(imageName: ImageResource, title: String, isActive: Bool) -> some View{
        HStack(spacing: 10){
            Spacer()
            Image(imageName)
                .resizable()
                .renderingMode(.template)
                .foregroundColor(isActive ? .black : .gray)
                .frame(width: 20, height: 20)
            if isActive{
                Text(title)
                    .font(.system(size: 14))
                    .foregroundColor(isActive ? .black : .gray)
            }
            Spacer()
        }
        .frame(width: isActive ? .infinity : 60, height: 60)
        .background(isActive ? .purple.opacity(0.4) : .clear)
        .cornerRadius(30)
    }
}
