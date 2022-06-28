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
    private var pinNumber: String?  // FIXME: 게임이 종료되거나, 게임 도중에 앱을 종료할 때 삭제해야할듯? PINNumber를 어떻게 이어갈지 헷갈림... -> 앱종료하면 자동으로 Coodinator가 삭제됨, 재시작하면 새로 핀넘버 만들거나 다른 핀넘버 입력하니까 상관없음 -> 메모리에서 해제되는지 확인 필요
    
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
    
    // TODO: 게임결과화면에서 다시 시작하기 누르면 finish를 호출 -> GameResult 또는 대기화면의 게임재시작 버튼을 눌렀을 때 호출해야할듯?
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
