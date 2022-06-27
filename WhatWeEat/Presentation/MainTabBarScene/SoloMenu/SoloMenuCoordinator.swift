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
    
    // 마찬가지
    // TODO: solo-C는 유지한 채로 초기화면으로 돌아가게만 해주면 되려나?
    func showInitialSoloMenuPage() {
//        delegate.removeFromChildCoordinatorsAndRestart(coordinator: self)
        
        let soloMenuViewModel = SoloMenuViewModel(coordinator: self)
        let soloMenuViewController = SoloMenuViewController(viewModel: soloMenuViewModel)
        
        navigationController?.viewControllers = [soloMenuViewController]
    }
}
