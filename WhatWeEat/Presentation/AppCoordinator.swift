import RxSwift
import UIKit

final class AppCoordinator: CoordinatorProtocol, OnboardingCoordinatorDelegate {
    // MARK: - Properties
    weak var navigationController: UINavigationController?
    var childCoordinators = [CoordinatorProtocol]()
    var type: CoordinatorType = .app
    
    // MARK: - Initializers
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    func start() {
        if FirstLaunchChecker.isFirstLaunched() {
            showOnboardingPage()
        } else {
            showMainTabBarPage()
        }
    }
    
    private func showOnboardingPage() {
        let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        onboardingCoordinator.delegate = self
        
        childCoordinators.append(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    func showMainTabBarPage() {
        let homeViewModel = HomeViewModel()
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        let togetherMenuViewModelactions = TogetherMenuViewModelAction(showSharePinNumberPage: showSharePinNumberPage)
        let togetherMenuViewModel = TogetherMenuViewModel(actions: togetherMenuViewModelactions)
        let togetherMenuViewController = TogetherMenuViewController(viewModel: togetherMenuViewModel)
        let soloMenuViewController = SoloMenuViewController()
        
        let mainTabBarViewModelAction = MainTabBarViewModelAction(showSettingPage: showSettingPage)
        let mainTabBarViewModel = MainTabBarViewModel(actions: mainTabBarViewModelAction)
        let mainTabBarController = MainTabBarController(
            pages: [homeViewController, togetherMenuViewController, soloMenuViewController],
            viewModel: mainTabBarViewModel
        )
        
        navigationController?.viewControllers = [mainTabBarController]
    }
    
    func removeFromChildCoordinators(coordinator: CoordinatorProtocol) {
        let updatedChildCoordinators = childCoordinators.filter { $0 !== coordinator }
        childCoordinators = updatedChildCoordinators
    }
    
    private func showSharePinNumberPage(with pinNumber: Observable<Data>) {
        let sharePinNumberPageViewModel = SharePinNumberPageViewModel(pinNumberData: pinNumber)
        let sharePinNumberPageViewController = SharePinNumberPageViewController(viewModel: sharePinNumberPageViewModel)
        
        navigationController?.pushViewController(sharePinNumberPageViewController, animated: false)
    }
    
    private func showSettingPage() {
//        let settingViewModelAction = SettingViewModelAction(
//            showDislikedFoodSurveyPage: showDislikedFoodSurveyPage,
//            showSettingDetailPage: showSettingDetailPageWith
//        )
//        let settingViewModel = SettingViewModel(actions: settingViewModelAction)
//        let settingViewController = SettingViewController(viewModel: settingViewModel)
//        
//        navigationController?.pushViewController(settingViewController, animated: true)
    }
    
//    private func showDislikedFoodSurveyPage() {
//        let actions = DislikedFoodSurveyViewModelAction(showMainTapBarPage: showMainTabBarPage, popCurrentPage: popCurrentPage)
//        let dislikedFoodSurveyViewModel = DislikedFoodSurveyViewModel(actions: actions)
//        let dislikedFoodSurveyViewController = DislikedFoodSurveyViewController(viewModel: dislikedFoodSurveyViewModel)
//
//        navigationController?.pushViewController(dislikedFoodSurveyViewController, animated: false)
//    }
    
    private func popCurrentPage() {
        navigationController?.popViewController(animated: false)
    }
    
    private func showSettingDetailPageWith(title: String, content: String) {
        let actions = SettingDetailViewModelAction(popCurrentPage: popCurrentPage)
        let settingDetailViewModel = SettingDetailViewModel(actions: actions)
        let settingDetailViewController = SettingDetailViewController(
            title: title,
            content: content,
            viewModel: settingDetailViewModel
        )
        
        navigationController?.pushViewController(settingDetailViewController, animated: false)
    }
    
    private func showAppStorePage() {
        // TODO: 링크를 통해 APPStore 앱 연결
    }
}

// MARK: - NameSpaces
extension AppCoordinator {
    private enum Content {
     
    }
}
