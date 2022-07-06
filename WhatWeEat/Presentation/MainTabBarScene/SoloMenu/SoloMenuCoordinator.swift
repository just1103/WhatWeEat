import UIKit

final class SoloMenuCoordinator: CoordinatorProtocol {
    var childCoordinators: [CoordinatorProtocol] = []
    var navigationController: UINavigationController?
    var type: CoordinatorType = .soloMenu
    weak var delegate: MenuCoordinatorDelegate!
    
    func start() {
    }
    
    func createSoloMenuViewController() -> UINavigationController {
        let soloMenuViewModel = SoloMenuViewModel(coordinator: self)
        let soloMenuViewController = SoloMenuViewController(viewModel: soloMenuViewModel)
        navigationController = UINavigationController(rootViewController: soloMenuViewController)
        navigationController?.navigationBar.isHidden = true
        
        guard let navigationController = navigationController else {
            return UINavigationController()
        }

        return navigationController
    }
    
    func showNetworkErrorPage() {
        let networkErrorViewModel = NetworkErrorViewModel(coordinator: self)
        let networkErrorViewController = NetworkErrorViewController(viewModel: networkErrorViewModel)
        
        navigationController?.pushViewController(networkErrorViewController, animated: false)
    }
    
    func showGamePage(with pinNumber: String? = nil) {
        guard let navigationController = navigationController else { return }
        let gameCoordinator = GameCoordinator(navigationController: navigationController, pinNumber: pinNumber)
        gameCoordinator.delegate = self
        childCoordinators.append(gameCoordinator)
        gameCoordinator.start()
    }
    
    func popCurrentPage() {
        navigationController?.popViewController(animated: true)
    }
}

extension SoloMenuCoordinator: SoloGameCoordinatorDelegate {
    func hideNavigationBarAndTabBar() {
        delegate.hideNavigationBarAndTabBar()
    }
    
    func showNavigationBarAndTabBar() {
        delegate.showNavigationBarAndTabBar()
    }
    
    func removeFromChildCoordinators(coordinator: CoordinatorProtocol) {
        let updatedChildCoordinators = childCoordinators.filter { $0 !== coordinator }
        childCoordinators = updatedChildCoordinators  
    }
    
    // solo-C는 유지
    func showInitialSoloMenuPage() {
//        delegate.removeFromChildCoordinatorsAndRestart(coordinator: self)
        
        let soloMenuViewModel = SoloMenuViewModel(coordinator: self)
        let soloMenuViewController = SoloMenuViewController(viewModel: soloMenuViewModel)
        
        navigationController?.viewControllers = [soloMenuViewController]
    }
}
