import RxSwift
import UIKit

final class TogetherMenuCoordinator: CoordinatorProtocol {
    var childCoordinators: [CoordinatorProtocol] = []
    var navigationController: UINavigationController?
    var type: CoordinatorType = .home
    weak var delegate: MenuCoordinatorDelegate!
    
    func start() {
    }
    
    func createTogetherMenuViewController() -> UINavigationController {
        let togetherMenuViewModel = TogetherMenuViewModel(coordinator: self)
        let togetherMenuViewController = TogetherMenuViewController(viewModel: togetherMenuViewModel)
        navigationController = UINavigationController(rootViewController: togetherMenuViewController)
        navigationController?.navigationBar.isHidden = true
        
        guard let navigationController = navigationController else {
            return UINavigationController()
        }

        return navigationController
    }
    
    func showSharePinNumberPage(with pinNumber: Observable<Data>) {
        let sharePinNumberPageViewModel = SharePinNumberPageViewModel(coordinator: self, pinNumberData: pinNumber)
        let sharePinNumberPageViewController = SharePinNumberPageViewController(viewModel: sharePinNumberPageViewModel)

        navigationController?.pushViewController(sharePinNumberPageViewController, animated: false)
    }
    
    func showGamePage(with pinNumber: String? = nil) {
        guard let navigationController = navigationController else { return }
        let gameCoordinator = GameCoordinator(navigationController: navigationController, pinNumber: pinNumber)
        gameCoordinator.delegate = self
        childCoordinators.append(gameCoordinator)
        gameCoordinator.start()
    }
    
    private func showInitialTogetherPage() {
        let togetherMenuViewModel = TogetherMenuViewModel(coordinator: self)
        let togetherMenuViewController = TogetherMenuViewController(viewModel: togetherMenuViewModel)
        
        navigationController?.viewControllers = [togetherMenuViewController] 
    }
}

extension TogetherMenuCoordinator: GameCoordinatorDelegate {
    func hideNavigationBarAndTabBar() {
        delegate.hideNavigationBarAndTabBar()
    }
    
    func showTabBar() {
        delegate.showTabBar()
    }
    
    func removeFromChildCoordinators(coordinator: CoordinatorProtocol) {
        let updatedChildCoordinators = childCoordinators.filter { $0 !== coordinator }
        childCoordinators = updatedChildCoordinators
    }
    
    func showTogetherPage() {
        delegate.removeFromChildCoordinatorsAndRestart(coordinator: self)
        showInitialTogetherPage()
//        guard let mainTabBarController = navigationController?.viewControllers.first as? MainTabBarController else {
//            return
//        }
//        mainTabBarController.selectedIndex = 1
//        navigationController?.viewControllers = [mainTabBarController]
    }
}
