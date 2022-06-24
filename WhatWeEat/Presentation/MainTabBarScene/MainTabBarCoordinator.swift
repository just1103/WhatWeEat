import RxSwift
import UIKit

final class MainTabBarCoordinator: CoordinatorProtocol, SettingCoordinatorDelegate, MenuCoordinatorDelegate {
    // MARK: - Properties
    var childCoordinators = [CoordinatorProtocol]()
    var navigationController: UINavigationController?
    var type: CoordinatorType = .tab
    
    private var mainTabBarController: MainTabBarController!
    
    // MARK: - Initializers
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        navigationController.navigationBar.isTranslucent = true
    }
    
    // MARK: - Methods
    func start() {
        makeMainTabBarPage()
        
        if TogetherGameSubmittedChecker.isSubmitted {
            mainTabBarController.selectedIndex = 1
            guard let togetherCoordinator = childCoordinators.filter { $0.type == .togetherMenu }.first as? TogetherMenuCoordinator else {
                return
            }
            
            togetherCoordinator.showLatestSubmissionPage(pinNumber: TogetherGameSubmittedChecker.latestPinNumber, token: "1111")  // TODO: 토큰 지정
        }
    }
    
    func showSettingPage() {
        guard let navigationController = navigationController else { return }
        let settingCoordinator = SettingCoordinator(navigationController: navigationController)
        settingCoordinator.settingCoordinatordelegate = self
        childCoordinators.append(settingCoordinator)
        settingCoordinator.start()
    }
    
//    func popCurrentPage() {
//        navigationController?.popViewController(animated: false)
//    }
    
    func hideNavigationBarAndTabBar() {
        navigationController?.navigationBar.isHidden = true
        mainTabBarController.tabBar.isHidden = true
    }
    
    func showNavigationBarAndTabBar() {
        navigationController?.navigationBar.isHidden = false
        mainTabBarController.tabBar.isHidden = false
    }
    
    func removeFromChildCoordinators(coordinator: CoordinatorProtocol) {
        let updatedChildCoordinators = childCoordinators.filter { $0 !== coordinator }
        childCoordinators = updatedChildCoordinators
    }
    
    func removeFromChildCoordinatorsAndRestart(coordinator: CoordinatorProtocol) {
        // ???: 아래를 해줘야할 것 같지만 없어도 정상작동한다...
//        let updatedChildCoordinators = childCoordinators.filter { $0 !== coordinator }
//        childCoordinators = updatedChildCoordinators
//        var newCoordinator: CoordinatorProtocol?
//        
//        switch coordinator {
//        case is TogetherMenuCoordinator:
//            newCoordinator = TogetherMenuCoordinator()
//        case is SoloMenuCoordinator:
//            newCoordinator = SoloMenuCoordinator()
//        case is HomeCoordinator:
//            newCoordinator = HomeCoordinator()
//        default:
//            break
//        }
//        
//        guard let newCoordinator = newCoordinator else { return }
//
//        childCoordinators.append(newCoordinator)
    }
    
    private func makeMainTabBarPage() {
        let homeCoordinator = HomeCoordinator()
        let togetherMenuCoordinator = TogetherMenuCoordinator()
        let soloMenuCoordinator = SoloMenuCoordinator()
        
        childCoordinators.append(homeCoordinator)
        childCoordinators.append(togetherMenuCoordinator)
        childCoordinators.append(soloMenuCoordinator)
        
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
