import RxSwift
import UIKit

final class MainTabBarCoordinator: CoordinatorProtocol, SettingCoordinatorDelegate, GameCoordinatorDelegate {
    // MARK: - Properties
    var childCoordinators = [CoordinatorProtocol]()
    var navigationController: UINavigationController?
    var type: CoordinatorType = .tab
    
    // MARK: - Initializers
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    func start() {
        makeMainTabBarPage()
    }
    
    func showSharePinNumberPage(with pinNumber: Observable<Data>) {
        let sharePinNumberPageViewModel = SharePinNumberPageViewModel(pinNumberData: pinNumber)
        let sharePinNumberPageViewController = SharePinNumberPageViewController(viewModel: sharePinNumberPageViewModel)
        
        navigationController?.pushViewController(sharePinNumberPageViewController, animated: false)
    }
    
    func showSettingPage() {
        guard let navigationController = navigationController else { return }
        let settingCoordinator = SettingCoordinator(navigationController: navigationController)
        settingCoordinator.settingCoordinatordelegate = self
        childCoordinators.append(settingCoordinator)
        settingCoordinator.start()
    }
    
    func popCurrentPage() {
        navigationController?.popViewController(animated: false)
    }
    
    func removeFromChildCoordinators(coordinator: CoordinatorProtocol) {
        let updatedChildCoordinators = childCoordinators.filter { $0 !== coordinator }
        childCoordinators = updatedChildCoordinators
    }
    
    private func makeMainTabBarPage() {
        let homeViewModel = HomeViewModel()
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        let togetherMenuViewModel = TogetherMenuViewModel(coordinator: self)
        let togetherMenuViewController = TogetherMenuViewController(viewModel: togetherMenuViewModel)
        let soloMenuViewModel = SoloMenuViewModel(coordinator: self)
        let soloMenuViewController = SoloMenuViewController(viewModel: soloMenuViewModel)
        let mainTabBarViewModel = MainTabBarViewModel(coordinator: self)
        let mainTabBarController = MainTabBarController(
            pages: [homeViewController, togetherMenuViewController, soloMenuViewController],
            viewModel: mainTabBarViewModel
        )
        
        navigationController?.viewControllers = [mainTabBarController]
    }
    
    func showGamePage() {
        guard let navigationController = navigationController else { return }
        let gameCoordinator = GameCoordinator(navigationController: navigationController)
        gameCoordinator.delegate = self
        childCoordinators.append(gameCoordinator)
        gameCoordinator.start()
    }
}
