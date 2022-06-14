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
        makeCardGamePage()
    }
    
    private func makeCardGamePage() {
        let cardGameViewModel = CardGameViewModel(coordinator: self)
        let cardGameViewController = CardGameViewController(viewModel: cardGameViewModel)
        
        navigationController?.pushViewController(cardGameViewController, animated: false)
    }
    
    func showMultipleChoiceGamePage(with cardGameResult: [Bool?]) {
        let multipleChoiceGameViewModel = MultipleChoiceGameViewModel(cardGameResults: cardGameResult, coordinator: self)
        let multipleChoiceGameViewController = MultipleChoiceGameViewController(viewModel: multipleChoiceGameViewModel)
        
        navigationController?.pushViewController(multipleChoiceGameViewController, animated: true)
    }
    
    func popCurrentPage() {
        navigationController?.popViewController(animated: true)
    }
}
