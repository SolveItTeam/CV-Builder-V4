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
                        viewModel.showPreview(cvtemplate: templatesList.first(where:  { $0.num == 2 }) ?? templatesList.first!)
                    } label: {
                        Image(.popularTemplates1)
                            .resizable()
                            .scaledToFit()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                    
                    Button {
                        viewModel.showPreview(cvtemplate: templatesList.first(where:  { $0.num == 4 }) ?? templatesList.first!)
                    } label: {
                        Image(.popularTemplates2)
                            .resizable()
                            .scaledToFit() 
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 16))
                }
                
                HStack {
                    Text(R.string.localizable.myResumes)
                        .font(Font(R.font.figtreeRegular.callAsFunction(size: 30)!))
                        .foregroundStyle(.white)
                    
                    Spacer()
                    
                    Button {
                        viewModel.showAllResumes()
                    } label: {
                        Image(.right)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 14, height: 14)
                    }
                    .buttonStyle(CircularButton())
                }
                .padding(.top, 10) 
                 
                if viewModel.historyItems.isEmpty {
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
                    VStack(spacing: -50) {
                        ForEach(Array(viewModel.historyItems.enumerated()), id: \.element.id) { index, item in
                            cvCard(item: item, index: index)
                        }
                    }
            
                }
                
                Spacer(minLength: 100)
            }
        }
        .padding(.horizontal, 16)
    }
    
    
    @ViewBuilder
    private func cvCard(item: HistoryItem, index: Int) -> some View {
        Button {
            viewModel.openResultView(historyItem: item)
        } label: {
            ZStack {
                AngledNotchCardShape(
                    cornerRadius: 32,
                    topAngleInset: 24,
                    topAngleHeight: 14,
                    centerWidth: 60
                )
                .fill(fillColor(for: index))
                .frame(height: 120)
                .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 3)
                
                HStack(alignment: .top, spacing: 0) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(item.jobTitle ?? R.string.localizable.untitled())
                            .font(Font(R.font.figtreeSemiBold(size: 20)!))
                            .foregroundColor(textColor(for: index))
                        
                        HStack {
                            Text(item.fullName ?? R.string.localizable.unnamed())
                                .font(Font(R.font.figtreeRegular(size: 16)!))
                                .foregroundColor(textColor(for: index))
                            
                            
                            Text(" |  " + formattedDate(item.creationDate ?? Date()))
                                .font(Font(R.font.figtreeRegular(size: 16)!))
                                .foregroundColor(textColor(for: index))
                        }
                    }
                    
                    Spacer()
                    
                    Menu {
                        Button {
                            
                        } label: {
                            Text(R.string.localizable.edit)
                                .font(.system(size: 17))
                                .foregroundColor(.black)
                            Image(systemName: "square.and.pencil")
                        }
                        
                        Button {
                            
                            // Rename action here.
                        } label: {
                            Text(R.string.localizable.rename)
                                .font(.system(size: 17))
                                .foregroundColor(.black)
                            Image(systemName: "square.and.arrow.up")
                        }
                        
                        Button(role: .destructive) {
                            viewModel.deleteItem(item)
                        } label: {
                            Text(R.string.localizable.delete())
                                .font(.system(size: 17))
                                .foregroundColor(.black)
                            Image(systemName: "trash")
                        }
                        
                    } label: {
                        Circle()
                            .fill(menuColor(for: index))
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(.moreV)
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 14, height: 14)
                                    .foregroundStyle(dotsColor(for: index))
                            )
                    }
                    .frame(alignment: .trailing)
                }
                .padding(.horizontal, 20)
            }
        }
    }

    private func fillColor(for index: Int) -> Color {
        switch index % 3 {
        case 2:
            return Color(.c393939)

        case 1:
            return Color(.cE1FF41)
        case 0:
            return Color(.c3200E0)
        default:
            return Color.clear
        }
    }
    
    private func textColor(for index: Int) -> Color {
        switch index % 3 {
        case 1:
            return Color(.blackMain)
        default:
            return Color(.white)
        }
    }
    
    private func menuColor(for index: Int) -> Color {
        switch index % 3 {
        case 2:
            return Color(.c686868).opacity(0.3)
        default:
            return Color(.white)
        }
    }
    
    private func dotsColor(for index: Int) -> Color {
        switch index % 3 {
        case 2:
            return  Color(.white)
        default:
            return Color(.blackMain)
        }
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, HH:mm"
        return formatter.string(from: date)
    }
}
