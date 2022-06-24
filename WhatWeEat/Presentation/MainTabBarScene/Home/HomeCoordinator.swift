import UIKit

final class HomeCoordinator: CoordinatorProtocol {    
    // MARK: - Properties
    var childCoordinators: [CoordinatorProtocol] = []
    var navigationController: UINavigationController? = UINavigationController()
    var type: CoordinatorType = .home
    
    // MARK: - Methods
    func start() {
    }
    
    func createHomeViewController() -> UINavigationController {
        let homeViewModel = HomeViewModel(coordinator: self)
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        navigationController = UINavigationController(rootViewController: homeViewController)
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
    
    func popCurrentPage() {
        navigationController?.popViewController(animated: true)
    }
}
