import SwiftUI

struct HistoryView: View {
    @ObservedObject var viewModel: HistoryViewModel
    
    var body: some View {
        VStack {
            if viewModel.isFromPush {
                BackButtonBar(showProIcon: $viewModel.showProIcon) {
                    viewModel.backTapped()
                } action: {
                    viewModel.showPaywall()
                }
            } else {
                NavBar(showProIcon: $viewModel.showProIcon) {
                    viewModel.showPaywall()
                }
                .padding(.horizontal, 16)
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
                        Text(item.jobTitle ?? "Untitled")
                            .font(Font(R.font.figtreeSemiBold(size: 20)!))
                            .foregroundColor(textColor(for: index))
                        
                        HStack {
                            Text(item.fullName ?? "Unnamed")
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
        switch index % 3 {
        case 2:
            return Color(.cD9D9D9)

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
                    Image(systemName: "doc.text.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                }
            
            Text("It's empty here yet")
                .font(.system(size: 20))
                .padding(.top, 16)
            
            Text("Create your first resume!")
                .font(.system(size: 16))
                .foregroundStyle(.gray)
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
import SwiftUI

struct AngledNotchCardShape: Shape {
    let cornerRadius: CGFloat
    
    let topAngleInset: CGFloat
    
    let topAngleHeight: CGFloat
    
    let centerWidth: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let totalTopWidth = rect.width - 2 * (cornerRadius + topAngleInset)
        let angledSegmentWidth = (totalTopWidth - centerWidth) / 2
        path.move(to: CGPoint(x: 0, y: cornerRadius))
        path.addQuadCurve(
            to: CGPoint(x: cornerRadius, y: 0),
            control: CGPoint(x: 0, y: 0)
        )
        
        let leftInsetEndX = cornerRadius + topAngleInset
        path.addLine(to: CGPoint(x: leftInsetEndX + 80, y: 0))
        
        let leftAngleEndX = leftInsetEndX + angledSegmentWidth
        path.addLine(to: CGPoint(x: leftAngleEndX, y: topAngleHeight))
        
        path.addLine(to: CGPoint(x: leftAngleEndX + centerWidth, y: topAngleHeight))
        
        let rightAngleStartX = leftAngleEndX + centerWidth
        let rightInsetStartX = rightAngleStartX + angledSegmentWidth
        path.addLine(to: CGPoint(x: rightInsetStartX - 80, y: 0))
        
        let topRightArcStartX = rect.width - cornerRadius
        path.addLine(to: CGPoint(x: topRightArcStartX, y: 0))
        path.addQuadCurve(
            to: CGPoint(x: rect.width, y: cornerRadius),
            control: CGPoint(x: rect.width, y: 0)
        )
        
        path.addLine(to: CGPoint(x: rect.width, y: rect.height - cornerRadius))
        path.addQuadCurve(
            to: CGPoint(x: rect.width - cornerRadius, y: rect.height),
            control: CGPoint(x: rect.width, y: rect.height)
        )
        
        path.addLine(to: CGPoint(x: cornerRadius, y: rect.height))
        path.addQuadCurve(
            to: CGPoint(x: 0, y: rect.height - cornerRadius),
            control: CGPoint(x: 0, y: rect.height)
        )
        
        path.closeSubpath()
        return path
    }
}

#Preview {
    HistoryView(viewModel: .init(coordinator: .init(), isFromPush: false))
}
