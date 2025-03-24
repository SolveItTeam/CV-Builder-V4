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
            .padding(.horizontal, 16)
            
            ScrollView {
                HStack {
                    Text(R.string.localizable.myResumes)
                        .font(Font(R.font.figtreeRegular(size: 30)!))
                        .foregroundStyle(.white)
                    
                    Spacer()
                }
                .padding(.top, 10)
                .padding(.horizontal, 16)
                
                VStack {
                    cvCard(cvTemplate: CreatedTemplate(cvData: CVConstructor(firstname: "", lastname: "", email: "", phone: "", summary: "", jobTitle: "", site: "", location: "", workExperience: [], education: [], skills: []), fileAbsolutePath: ""))
                }
                .padding(.horizontal, 16)
            }
            .overlay {
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
                        
                        Button {
                            viewModel.showResumeTemplates()
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
                        .padding(.top, 20)
                        .padding(.horizontal, 16)
                    }
                }
            }
        }
    }
    
    @ViewBuilder private func cvCard(cvTemplate: CreatedTemplate) -> some View {
        ZStack {
            // Tweak these to match your design precisely
            AngledNotchCardShape(
                cornerRadius: 32,
                topAngleInset: 24,
                topAngleHeight: 14,    // positive means it goes *above* the top edge
                centerWidth: 60
            )
            .fill(Color.yellow)
            .frame(height: 120)
            .shadow(color: .black.opacity(0.15), radius: 4, x: 0, y: 3)
            
            // Sample text/icons on top
            HStack(spacing: 12) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Graphic Designer")
                        .font(.headline)
                        .foregroundColor(.black)
                    Text("Julia Beil | 10.04.2025, 15:45")
                        .foregroundColor(.black.opacity(0.8))
                        .font(.subheadline)
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
                        
                    } label: {
                        Text("Rename")
                            .font(.system(size: 17))
                            .foregroundColor(.black)
                        Image(systemName: "square.and.arrow.up")
                    }
                    
                    Button(role: .destructive) {
                         
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
                                .foregroundStyle(.blackMain)
                        )
                }
            }
            .padding(.horizontal, 20)
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
    HistoryView(viewModel: .init(coordinator: .init()))
}
