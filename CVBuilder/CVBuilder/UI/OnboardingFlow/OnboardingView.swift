//
//  OnboardingView.swift
//  CVBuilder
//
//  Created by Roman on 24.03.25.
//


import SwiftUI

struct OnboardingView: View {
    @State var currentIndex: OnboardingMetaData = .page1
    @StateObject var viewModel: OnboardingViewModel
    @State private var showNotNowButton = false
    
    var subtitle: String {
        return currentIndex.subtitle
    }
    
    var mainButtonTitle: String {
        guard currentIndex == .page4
                && viewModel.remoteConfig.config.paywallConfig.isPriceTitle else {
            return R.string.localizable.continue()
        }
        
        return R.string.localizable.start() + " \(viewModel.weekOffer) " + "/" + R.string.localizable.week()
    }
    
    
    var body: some View {
        VStack(alignment: .leading) {
                Image(currentIndex.image)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
            HStack {
                Spacer()
                PageDots(
                    pageCount: OnboardingMetaData.allCases.count,
                    currentIndex:  Binding(
                        get: { currentIndex.num },
                        set: { currentIndex = OnboardingMetaData.allCases[$0] }
                    )
                )
                Spacer()
            }
                
            VStack(alignment: .leading, spacing: 12) {
                    Text(currentIndex.title)
                        .font(Font(R.font.figtreeSemiBold(size: 32)!))
                        .foregroundStyle(.white)
                        .padding(.bottom, 2)
                    
                    if currentIndex == .page5 {
                        Text(R.string.localizable.startToContinueAppWith3DaysTrialWeek(viewModel.weekOffer + " " + R.string.localizable.perWeek()))
                            .font(Font(R.font.figtreeRegular(size: 16)!))
                            .foregroundStyle(.c686868)
                        
                        .fixedSize(horizontal: false, vertical: true)
                    } else {
                        Text(currentIndex.subtitle )
                            .font(Font(R.font.figtreeRegular(size: 16)!))
                            .foregroundStyle(.c686868)
                        
                        .fixedSize(horizontal: false, vertical: true)
                    }
                    
                }
                .multilineTextAlignment(.leading)
                .padding(.horizontal, 12)
                .padding(.bottom, 10)
            VStack {
                PulsateButton(text: mainButtonTitle) {
                    viewModel.occureImpact()
                    switch currentIndex {
                    case .page1:
                        currentIndex = .page2
                        
                    case .page2:
                        if !viewModel.isAppRateShown {
                            if viewModel.remoteConfig.config.enabledAppRatingRequest {
                                viewModel.requestAppRate()
                                viewModel.endAppRatinCall()
                            } else {
                                currentIndex = .page3
                            }
                        } else {
                            currentIndex = .page3
                        }
                        
                    case .page3:
                        currentIndex = .page4
                    case .page4:
                        currentIndex = .page5
                        DispatchQueue.main.asyncAfter(deadline: .now() + viewModel.crossDisabledDuration) {
                            withAnimation {
                                showNotNowButton = true
                            }
                        }
                    case .page5:
                        Task {
                            await viewModel.processPurchase()
                        }
                    }
                }
                .padding(.bottom, 4)
                
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
                        Text(R.string.localizable.termss())
                            .font(Font(R.font.figtreeRegular(size: 12)!))
                            .foregroundStyle(.cB6B6B6)
                            .underline()
                            .lineLimit(1)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    
                    Spacer()
                    
                    Button {
                        Task {
                            await viewModel.restoreTapped()
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
                .opacity(currentIndex == .page5 ? 1 : 0)
                .disabled(currentIndex != .page5)
                .animation(.easeInOut, value: currentIndex)
                .padding(.horizontal,  16)
            }
        }
        .overlay(alignment: .topTrailing, content: {
            Button {
                viewModel.finishedOnboarding()
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
        .animation(.default, value: currentIndex)
        .navigationBarHidden(true)
        .overlay (
            CustomProgressView(isShown: $viewModel.isProductsLoading)
                .animation(.default, value: viewModel.isProductsLoading)
        )
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
                            viewModel.onNotNowTapped()
                        }
                    }
                )
            }
        }
        .task {
            await viewModel.loadPaywall(placementId: .place)
        }
    }
}


#Preview {
    OnboardingView(currentIndex: .page1, viewModel: .init(coordinator: .init(), finishedOnboarding: {}))
}
