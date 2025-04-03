import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel
    
    var body: some View {
        VStack {
            BackButtonBar(showProIcon: $viewModel.showProIcon) {
                viewModel.backTapped()
            } action: {
                viewModel.showPaywall()
            }
            
            
            ScrollView {
                HStack {
                    Text(R.string.localizable.myResumes())
                        .font(.system(size: 30))
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                .padding(.top, 10)
                .padding(.horizontal, 16)
                
                VStack(spacing: 0) {
                    VStack(spacing: 8) {
                        ForEach(Array(viewModel.historyItems.enumerated()), id: \.element.id) { index, item in
                            cvCard(item: item, index: index)
                        }
                        
                        Spacer(minLength: 50)
                        
                    }
                }
                .padding(.horizontal, 16)
            }
            .overlay {
                if viewModel.historyItems.isEmpty {
                    VStack(spacing: 16) {
                        emptyStateView
                    }
                }
            }
        }
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
    
    @ViewBuilder
    private var emptyStateView: some View {
        VStack(spacing: 0) {
            Circle().fill(.gray.opacity(0.6))
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
            
            Button {
                viewModel.showResumeTemplates()
            } label: {
                Text(R.string.localizable.create())
                    .font(Font(R.font.figtreeSemiBold(size: 20)!))
                    .foregroundColor(.blackMain)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.cE1FF41)
                    .clipShape(RoundedRectangle(cornerRadius: 32))
                    .contentShape(Rectangle())
            }
            .buttonStyle(ScaleButtonStyle())
            .padding(.top, 20)
        }
    }
}



#Preview {
    HistoryView(viewModel: .init(coordinator: .init()))
}
