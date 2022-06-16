import RxSwift
import UIKit

final class MainTabBarCoordinator: CoordinatorProtocol, SettingCoordinatorDelegate, MenuCoordinatorDelegate {
    // MARK: - Properties
    var childCoordinators = [CoordinatorProtocol]()
    var navigationController: UINavigationController?
    var type: CoordinatorType = .tab
    
    private let homeCoordinator = HomeCoordinator()
    private weak var soloMenuCoordinator: SoloMenuCoordinator!
    private weak var togetherMenuCoordinator: TogetherMenuCoordinator!
    private var mainTabBarController: MainTabBarController!
    
    // MARK: - Initializers
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    func start() {
        makeMainTabBarPage()
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
    
    func hideNavigationBarAndTabBar() {
        navigationController?.navigationBar.isHidden = true
        mainTabBarController.tabBar.isHidden = true
    }
    
    func showTabBar() {
        navigationController?.navigationBar.isHidden = false
        mainTabBarController.tabBar.isHidden = false
    }
    
    func removeFromChildCoordinatorsAndRestart(coordinator: CoordinatorProtocol) {
        let updatedChildCoordinators = childCoordinators.filter { $0 !== coordinator }
        childCoordinators = updatedChildCoordinators
        var newCoordinator: CoordinatorProtocol?
        
        switch coordinator {
        case is TogetherMenuCoordinator:
            newCoordinator = TogetherMenuCoordinator()
        case is SoloMenuCoordinator:
            newCoordinator = SoloMenuCoordinator()
        case is HomeCoordinator:
            newCoordinator = HomeCoordinator()
        default:
            break
        }
        
        guard let newCoordinator = newCoordinator else { return }

        childCoordinators.append(newCoordinator)
    }
    
    private func makeMainTabBarPage() {
        let homeCoordinator = HomeCoordinator()
        let soloMenuCoordinator = SoloMenuCoordinator()
        let togetherMenuCoordinator = TogetherMenuCoordinator()
        
        childCoordinators.append(homeCoordinator)
        childCoordinators.append(soloMenuCoordinator)
        childCoordinators.append(togetherMenuCoordinator)
        
        soloMenuCoordinator.delegate = self
        togetherMenuCoordinator.delegate = self
        
        let homeViewController = homeCoordinator.createHomeViewcontroller()
        let soloMenuViewController = soloMenuCoordinator.createSoloMenuViewcontroller()
        let togetherMenuViewController = togetherMenuCoordinator.createTogetherMenuViewController()
        let mainTabBarViewModel = MainTabBarViewModel(coordinator: self)
        mainTabBarController = MainTabBarController(
            viewModel: mainTabBarViewModel,
            pages: [homeViewController, togetherMenuViewController, soloMenuViewController]
        )

        navigationController?.viewControllers = [mainTabBarController]
    }
}
