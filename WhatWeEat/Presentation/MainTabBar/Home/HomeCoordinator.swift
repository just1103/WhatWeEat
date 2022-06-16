import UIKit

final class HomeCoordinator: CoordinatorProtocol {
    var childCoordinators: [CoordinatorProtocol] = []
    var navigationController: UINavigationController? = UINavigationController()
    var type: CoordinatorType = .home
    
    func start() {
    }
    
    func createHomeViewcontroller() -> UINavigationController {
        let homeViewModel = HomeViewModel()
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        navigationController = UINavigationController(rootViewController: homeViewController)
        navigationController?.navigationBar.isHidden = true
        
        guard let navigationController = navigationController else {
            return UINavigationController()
        }

        return navigationController
    }
}
