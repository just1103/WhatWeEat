import UIKit
import RxSwift

protocol SoloGameCoordinatorDelegate: GameCoordinatorDelegate {
    func showInitialSoloMenuPage()
}

protocol TogetherGameCoordinatorDelegate: GameCoordinatorDelegate {
    func showInitialTogetherMenuPage()
}

protocol GameCoordinatorDelegate: AnyObject {
    func hideNavigationBarAndTabBar()
    func showNavigationBarAndTabBar()
    func removeFromChildCoordinators(coordinator: CoordinatorProtocol)
}

final class GameCoordinator: CoordinatorProtocol {
    // MARK: - Properties
    var childCoordinators = [CoordinatorProtocol]()
    var navigationController: UINavigationController?
    var type: CoordinatorType = .game
    weak var delegate: GameCoordinatorDelegate!
    private var pinNumber: String?  // TODO: 게임이 종료되는 시점에 메모리에서 해제되는지 확인 필요
    
    // MARK: - Initializers
    init(navigationController: UINavigationController, pinNumber: String?) {
        self.navigationController = navigationController
        self.pinNumber = pinNumber
    }
    
    // MARK: - Methods
    func start() {
        makeCardGamePage(with: pinNumber)
        delegate.hideNavigationBarAndTabBar()
    }

    func finish() {
        delegate.removeFromChildCoordinators(coordinator: self)
    }
    
    func showGameResultPage(with pinNumber: String?, soloGameResult: GameResult?) {
        let gameResultViewModel = GameResultViewModel(coordinator: self, pinNumber: pinNumber, soloGameResult: soloGameResult)
        let gameResultViewController = GameResultViewController(viewModel: gameResultViewModel)
        
        navigationController?.pushViewController(gameResultViewController, animated: false)
        delegate.showNavigationBarAndTabBar()
    }
    
    func showSubmissionPage(pinNumber: String) {
        let submissionViewModel = ResultWaitingViewModel(coordinator: self, pinNumber: pinNumber)
        let submissionViewController = ResultWaitingViewController(viewModel: submissionViewModel)
        
        navigationController?.pushViewController(submissionViewController, animated: false)
        delegate.showNavigationBarAndTabBar()
    }
    
    func popCurrentPage() {
        navigationController?.popViewController(animated: true)
    }
    
    func showInitialTogetherMenuPage() {
        guard let togetherGameCoordinatorDelegate = delegate as? TogetherGameCoordinatorDelegate else { return }
        togetherGameCoordinatorDelegate.showInitialTogetherMenuPage()
    }
    
    func showInitialSoloMenuPage() {
        guard let soloGameCoordinatorDelegate = delegate as? SoloGameCoordinatorDelegate else { return }
        soloGameCoordinatorDelegate.showInitialSoloMenuPage()
    }
    
    private func makeCardGamePage(with pinNumber: String?) {
        let cardGameViewModel = CardGameViewModel(coordinator: self, pinNumber: pinNumber)
        let cardGameViewController = CardGameViewController(viewModel: cardGameViewModel)
        
        navigationController?.pushViewController(cardGameViewController, animated: false)
    }
}
