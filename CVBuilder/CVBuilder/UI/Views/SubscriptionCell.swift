import SwiftUI

struct SubscriptionCell: View {
    var isChosen: Bool
    let title: String
    let subTitle: String
    let price: String
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            VStack(alignment: .leading) {
                HStack(alignment: .center) {
                    
                    Image(isChosen ? .tick : .untick)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Text(title)
                            .font(Font(R.font.figtreeSemiBold(size: 20)!))
                            .foregroundColor( isChosen ? .white : .cA1A1A1 )
                        
                      
                        
                    }
                    
                    Spacer()
                     
                            Text(subTitle)
                                .font(Font(R.font.figtreeRegular(size: 16)!))
                                .foregroundColor( isChosen ? .white : .cA1A1A1 )
 
                    
                }
            }
            .padding(.vertical, 18)
            .padding(.horizontal, 24)
            .clipShape(RoundedRectangle(cornerRadius: 60))
            .contentShape(RoundedRectangle(cornerRadius: 60))
            .overlay {
                if !isChosen {
                    RoundedRectangle(cornerRadius: 60)
                        .stroke(.cA1A1A1, lineWidth: 1)
                }
            }
            .overlay {
                if isChosen {
                    RoundedRectangle(cornerRadius: 60)
                        .stroke(.cE1FF41, lineWidth: 1)
                }
            }
        }
        .buttonStyle(ScaleButtonStyle())
        .frame(height: 60)
    }
}

