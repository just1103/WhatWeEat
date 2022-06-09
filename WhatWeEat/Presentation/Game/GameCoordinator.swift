import UIKit

protocol GameCoordinatorDelegate: AnyObject {
    func removeFromChildCoordinators(coordinator: CoordinatorProtocol)
}

final class GameCoordinator: CoordinatorProtocol {
    // MARK: - Properties
    var childCoordinators = [CoordinatorProtocol]()
    var navigationController: UINavigationController?
    var type: CoordinatorType = .game
    weak var delegate: GameCoordinatorDelegate!
    
    // MARK: - Initializers
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    func start() {
        makeGamePage()
    }
    
    private func makeGamePage() {
        let gameViewController = GameViewController()
        
        navigationController?.pushViewController(gameViewController, animated: false)
    }
}
