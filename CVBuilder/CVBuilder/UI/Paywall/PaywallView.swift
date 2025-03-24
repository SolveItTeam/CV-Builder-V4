
import SwiftUI

struct PaywallView: View {
    @StateObject var viewModel: PaywallViewModel
    @State var tappedCell: Bool = false
    
    @State private var showNotNowButton = false
    private let isSmallScreen = Constants.screenHeight < Constants.smallScreenHeight
    var mainButtonTitle: String {
        guard viewModel.remoteConfig.config.paywallConfig.isPriceTitle else {
            return R.string.localizable.continue()
        }
        
        return R.string.localizable.start() + " \((viewModel.selectedProduct?.localizedPrice ?? ""))/" + R.string.localizable.week()
    }
    

    
    var body: some View {
        
        VStack {
                Image(.paywall)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea(edges: .all)
         
                content()
                 
        }
        .overlay {
            CustomProgressView(isShown: $viewModel.isLoading)
                .animation(.default, value: viewModel.isLoading)
        }
        .alert(isPresented: $viewModel.isShowingAlert) {
            switch viewModel.alertCategory {
            case .cancelles:
                return Alert(
                    title: Text(viewModel.errorHandler.title),
                    message: Text(viewModel.errorHandler.subTitle),
                    primaryButton: .default(
                        Text(R.string.localizable.tryAgain)
                    ) {
                        Task {
                            await viewModel.processPurchase()
                        }
                    },
                    secondaryButton: .cancel(
                        Text(R.string.localizable.cancelTitle)
                    ) {}
                )
            case .common:
                return Alert(
                    title: Text(viewModel.errorHandler.title),
                    message: Text(viewModel.errorHandler.subTitle),
                    dismissButton: .default(
                        Text(R.string.localizable.okTitle)
                    ) {
                        if viewModel.purchaseService.isPremium {
                            viewModel.closePaywall()
                        }
                    }
                )
            }
        }
        .overlay(alignment: .topTrailing, content: {
            Button {
                viewModel.closePaywall()
            } label: {
                Image(.crossWithFrame)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
            .disabled(!showNotNowButton)
            .opacity(showNotNowButton ? viewModel.closOpacity : 0)
            .padding(16)
        })
        .task {
            await viewModel.loadPaywall(placementId: .place)
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + viewModel.crossDisabledDuration) {
                withAnimation {
                    showNotNowButton = true
                }
            }
        }
    }
    
    @ViewBuilder private func content() -> some View {
        VStack {
            Text(R.string.localizable.upgradeToPROVersion)
                .font(Font(R.font.figtreeBold(size: 30)!))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 16)
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .padding(.bottom, 4)
            
 
                        
            Text(viewModel.subtitle)
                .font(Font(R.font.figtreeRegular(size: 16)!))
                .foregroundStyle(.c686868)
                .multilineTextAlignment(.leading)
            }
            .padding(.horizontal, 16)
            
        Spacer()
            
            VStack(spacing: 8) {
                    ForEach(viewModel.appProducts) { product in
                        SubscriptionCell(
                            isChosen: viewModel.selectedProduct == product,
                            
                            title:  product.localizedTitle,
                            
                            subTitle: viewModel.formatPrice(price: product.localizedPrice, description: product.localizedDescription.lowercased()),
                            
                            price:  product.localizedTitle == ProductTitle.weeklyProductTitle ? product.localizedPrice : String(viewModel.formatForWeekPrice(from: product.localizedPrice, period: product.localizedTitle == ProductTitle.monthlyProductTitle ? .monthly : .annual))
                        ) {
                            viewModel.selectProduct(product: product)
                        }
                        .overlay(alignment: .topTrailing) {
                            Group {
                                if product.localizedTitle == ProductTitle.weeklyProductTitle {
                                    HStack {
                                        Text(R.string.localizable.daysFreeTrial)
                                            .font(Font(R.font.figtreeRegular(size: 11)!))
                                                           .foregroundStyle(.blackMain)
                                            .padding(.vertical, 4)
                                            .padding(.horizontal, 10)
                                    }
                                    .background(.cE1FF41)
                                    .clipShape(RoundedRectangle(cornerRadius: 16))
                                    .padding(.top, -14)
                                    .padding(.trailing, 18)
                                }
                            }
                        }
                    }
            }
            .padding(.bottom, 10)
            .padding(.horizontal, 16)
            
            VStack(spacing: 12) {
                PulsateButton(text: viewModel.navigationTitle) {
                    viewModel.onContinueButtonPressed()
                }
                .padding(.horizontal, 16)
                
                HStack(alignment: .top, spacing: 0) {
                    Text(R.string.localizable.byContinuingYouAgreeTo)
                        .font(Font(R.font.figtreeRegular(size: 12)!))
                        .foregroundStyle(.cB6B6B6)
                    
                    Spacer()
                    
                    Button(action: viewModel.onPrivacyPolicyTapped) {
                        Text(R.string.localizable.privacy())
                            .font(Font(R.font.figtreeRegular(size: 12)!))
                            .foregroundStyle(.cB6B6B6)
                            .underline()
                            .lineLimit(1)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer()
                    
                    Button(action: viewModel.onTermsOfUseTapped) {
                        Text(R.string.localizable.terms())
                            .font(Font(R.font.figtreeRegular(size: 12)!))
                            .foregroundStyle(.cB6B6B6)
                            .underline()
                            .lineLimit(1)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer()
                    
                    Button {
                        Task {
                            await viewModel.onRestoreTapped()
                        }
                    } label: {
                        Text(R.string.localizable.restore())
                            .font(Font(R.font.figtreeRegular(size: 12)!))
                            .underline()
                            .foregroundStyle(.cB6B6B6)
                            .lineLimit(1)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                .padding(.horizontal, 16)
 
        }
        .ignoresSafeArea()
    }
}

#Preview {
    PaywallView(viewModel: .init(coordinator: .init()))
}
