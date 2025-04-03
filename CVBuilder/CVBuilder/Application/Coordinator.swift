import SwiftUI
import Reachability
import PDFKit

final class Coordinator: NSObject {
    @AppStorage(Constants.AppStorageKeys.isOnboardingCompleted) var isOnboardingCompleted: Bool = false
    var couldFetchFromBackground: Bool = false
    var window: UIWindow!
    var navigationController: UINavigationController
    let keychainStorage: KeychainService
    let cancelBag: Cancellable
    var reachibility: Reachability?
    var shouldShowPaywall: Bool = true
    private let remoteConfig: AppRemoteConfigService = .shared
    
    private var isPaywallPresented: Bool  = false
    
    init(
        window: UIWindow? = nil,
        navigationController: UINavigationController = UINavigationController()
    ) {
        self.window = window
        self.navigationController = navigationController
        self.navigationController.navigationBar.isHidden = true
        self.cancelBag = Cancellable()
        self.reachibility = try? Reachability()
        try? reachibility?.startNotifier()
        self.keychainStorage = .init()
        super.init()
        UIView.appearance(whenContainedInInstancesOf: [UIAlertController.self]).tintColor = UIColor(named: "AccentColor")
        setupNetworkObserver()
    }
    
    func start() {
        let launchController = UIHostingController(rootView: LaunchScreenView())
        
        navigationController.setViewControllers([launchController],
                                                animated: true)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        
        sinkWithNotificationCenter()
        
        Task {
            await fetchAppConfigAndPurchases()
            
            await MainActor.run { [weak self] in
                guard let self else { return }
                if isOnboardingCompleted || PurchaseManager.shared.isPremium {
                    startMainFlow()
                } else {
                    startOnboarding()
                }
            }
            
        }
        
        PaymentRefunder.shared.closeAction = { [weak self] in
            self?.popToRootView()
        }
    }
    
    func startMainFlow() {
        guard let window else { return }
        let vc = UIHostingController(rootView: MainTabbedView(
            coordinator: self,
            homeView: HomeView(viewModel: .init(coordinator: self)),
            templatesView: PopularTemplatesView(viewModel: .init(coordinator: self, isFromPush: false)),
            coverLetterView: CoverLetterView(viewModel: .init(coordinator: self)),
            settingsView: SettingsView(viewModel: .init(coordinator: self))
        ))
        
        UIView.transition(with: window, duration: 0.4, options: .transitionCrossDissolve, animations: { [weak self] in
            guard let self else { return }
            
            navigationController.setViewControllers(
                [vc],
                animated: false
            )
        })
    }
    
    func startOnboarding() {
        let onboardingViewController = UIHostingController(
            rootView: OnboardingView(
                viewModel: .init(
                    coordinator: self,
                    finishedOnboarding: { [weak self] in
                        self?.isOnboardingCompleted = true
                        self?.startMainFlow()
                    }
                )
            )
        )
        
        navigationController.setViewControllers([onboardingViewController], animated: true)
        
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
    }
    
    func showProfileView(chosenTemplate: CVTemplate? = nil) {
        let viewModel: ProfileViewModel
        if let chosenTemplate {
            viewModel = ProfileViewModel(coordinator: self, chosenTemplate: chosenTemplate) { [weak self] in
                guard let self else { return }
                let resultViewModel = ResultViewModel(coordinator: self,
                                                      chosenTemplate: chosenTemplate, isResult: false, historyItem: nil)
                let resultView = ResultView(viewModel: resultViewModel)
                
                dismissSheet()
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3 ) { [weak self] in 
                    self?.navigationController.pushViewController(UIHostingController(rootView: resultView), animated: true)
                }
            }
        } else {
            viewModel = .init(coordinator: self, chosenTemplate: chosenTemplate, resultCompletion: nil)
        }
         let profileCV = (UIHostingController(rootView: ProfileView(viewModel: viewModel)))
        profileCV.modalPresentationStyle = .fullScreen
        navigationController.present(profileCV, animated: true)
    }
    
    func showResumeTemplates() {
        let cvTemplate = PopularTemplatesView(viewModel: .init(coordinator: self, isFromPush: true))
        
        navigationController.pushViewController((UIHostingController(rootView:  cvTemplate)), animated: true)
    }
    
    func showTemplatePreview(cvTemplate: CVTemplate) {
        let cvTemplate = TemplatePreviewView(viewModel: .init(coordinator: self, chosenTemplate: cvTemplate))
        
        navigationController.pushViewController((UIHostingController(rootView:  cvTemplate)), animated: true)
    }
    
    func showHistoryItem(historyItem: HistoryItem?) {
        let resVC = UIHostingController(rootView:  ResultView(viewModel: .init(coordinator: self, chosenTemplate: .init(num: 0, templatePreview: .CV, fileToUseString: ""), isResult: true, historyItem: historyItem)))
        
        navigationController.pushViewController(resVC, animated: true)
    }

    func showPaywall() {
        guard shouldShowPaywall, !isPaywallPresented else { return }
        
        isPaywallPresented = true
        
        let payWallViewController = UIHostingController(rootView: PaywallView(viewModel: .init(coordinator: self)))
        
            payWallViewController.modalPresentationStyle = .fullScreen

        
        navigationController.present(payWallViewController, animated: true) { [weak self] in
            self?.isPaywallPresented = false
        }
    }
    
    func showFullHistory() {
        let historyVC = UIHostingController(rootView:  HistoryView(viewModel: .init(coordinator: self)))
        navigationController.pushViewController(historyVC, animated: true)
        
    }
}

extension Coordinator {
    func dismissSheet(withAnimation: Bool = true) {
        navigationController.dismiss(animated: withAnimation)
    }
    
    func popToRootView() {
        navigationController.popToRootViewController(animated: true)
    }
    
    func popView() {
        navigationController.popViewController(animated: true)
    }
    
    func showRateUs() {
        UIApplication.shared.requestReview()
    }
    
    func showShareApp() {
        UIApplication.shared.actionSheetShare(localizedShareText: "")
    }
    
    func showPrivacyPolicy() {
        UIApplication.shared.privacyPolicy()
    }
    
    func showTermsOfUse() {
        UIApplication.shared.termsPolicy()
    }
    
    func openContactUs() {
        PaymentRefunder.shared.present(
            errorTitle: "There is an error",
            errorMessage: "Please, setup default mail client and contact us:\n" + "\(ConfigValues.getValue().email)\n",
            supportEmail: ConfigValues.getValue().email
        )
    }
    
    static func addShortcutActionMenu() {
        let shortcutItem = UIApplicationShortcutItem(
            type: ActionTypeQuick.mail.rawValue,
            localizedTitle: "Refund Payment",
            localizedSubtitle: "Please, contact us if you have any issues",
            icon: UIApplicationShortcutIcon(type: .cloud),
            userInfo: nil
        )
        UIApplication.shared.shortcutItems = [shortcutItem]
    }
    
    private func sinkWithNotificationCenter() {
        NotificationCenter
            .default
            .sceneLifecycleEventPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] event in
                guard let self else { return }
                switch event {
                case .didEnterBackground:
                    break
                case .willEnterForeground:
                    Task { [weak self] in
                        await self?.fetchAppConfigAndPurchases()
                    }
                }
            }
            .store(in: cancelBag)
    }
    
    private func setupNetworkObserver() {
        reachibility?.whenReachable = { [weak self] _ in
            self?.shouldShowPaywall = true
        }
        reachibility?.whenUnreachable = { [weak self] _ in
            self?.shouldShowPaywall = false
        }
        
        try? reachibility?.startNotifier()
    }
    
    private func fetchAppConfigAndPurchases() async {
        try? await AppRemoteConfigService.shared.startFetching()
        await PurchaseManager.shared.fetchAdaptyProfile()
        if !PurchaseManager.shared.isPremium && isOnboardingCompleted {
            try? await Task.sleep(nanoseconds: 1_000_000_000)
            await MainActor.run { [weak self] in
           //     self?.showPaywall()
            }
        }
    }
}
