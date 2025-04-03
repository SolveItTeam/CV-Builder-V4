import SwiftUI

struct CoverLetterView: View {
    @ObservedObject var viewModel: HistoryViewModel
    
    var body: some View {
        VStack {
            NavBar(showProIcon: $viewModel.showProIcon) {
                viewModel.showPaywall()
            }
            .padding(.horizontal, 16)
            
            ScrollView {
                HStack {
                    Text(R.string.localizable.myCoverLetters())
                        .font(.system(size: 30))
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                .padding(.top, 10)
                .padding(.horizontal, 16)
                
                VStack(spacing: 0) {
                    if viewModel.historyItems.isEmpty {
                        VStack(spacing: 16) {
                            emptyStateView
                        }
                    } else {
                        VStack(spacing: 8) {
                            ForEach(Array(viewModel.historyItems.enumerated()), id: \.element.id) { index, item in
                                cvCard(item: item, index: index)
                            }
                            
                            Spacer(minLength: 50)
                        }
                    }
                }
                .padding(.horizontal, 16)
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
                            Text("Rename")
                                .font(.system(size: 17))
                                .foregroundColor(.black)
                            Image(systemName: "square.and.arrow.up")
                        }
                        
                        Button(role: .destructive) {
                            viewModel.deleteItem(item)
                        } label: {
                            Text("Delete")
                                .font(.system(size: 17))
                                .foregroundColor(.black)
                            Image(systemName: "trash")
                        }
                        
                    } label: {
                        Circle()
                            .fill(Color.white)
                            .frame(width: 60, height: 60)
                            .overlay(
                                Image(.moreV)
                                    .renderingMode(.template)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 14, height: 14)
                                    .foregroundStyle(.black)
                            )
                    }
                    .frame(alignment: .trailing)
                }
                .padding(.horizontal, 20)
            }
        }
    }
    
    private func fillColor(for index: Int) -> Color {
        return Color(.c686868).opacity(0.3)
    }
    
    private func textColor(for index: Int) -> Color {
        return Color(.white)
    }
    
    private func menuColor(for index: Int) -> Color {
        return Color(.c686868).opacity(0.3)
    }
    
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy, HH:mm"
        return formatter.string(from: date)
    }
    
    @ViewBuilder
    private var emptyStateView: some View {
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
            
            
            Button {
                viewModel.showResumeTemplates()
            } label: {
                Text("Create")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.black)
                    .frame(maxWidth: .infinity)
                    .frame(height: 60)
                    .background(Color.yellow)
                    .clipShape(RoundedRectangle(cornerRadius: 32))
                    .contentShape(Rectangle())
            }
            .padding(.top, 20)
        }
    }
}
