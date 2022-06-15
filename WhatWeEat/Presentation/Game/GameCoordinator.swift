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
    private var pinNumber: String?  // FIXME: 게임이 종료되거나, 게임 도중에 앱을 종료할 때 삭제해야할듯? PINNumber를 어떻게 이어갈지 헷갈림... -> 앱종료하면 자동으로 Coodinator가 삭제됨, 재시작하면 새로 핀넘버 만들거나 다른 핀넘버 입력하니까 상관없음
    
    // MARK: - Initializers
    init(navigationController: UINavigationController, pinNumber: String?) {
        self.navigationController = navigationController
        self.pinNumber = pinNumber
    }
    
    // MARK: - Methods
    func start() {
        makeCardGamePage(with: pinNumber)  
    }
    
    private func makeCardGamePage(with pinNumber: String?) {
        let cardGameViewModel = CardGameViewModel(coordinator: self, pinNumber: pinNumber)
        let cardGameViewController = CardGameViewController(viewModel: cardGameViewModel)
        
        navigationController?.pushViewController(cardGameViewController, animated: false)
    }
    
    func showSubmissionPage(pinNumber: String) {
        let submissionViewModel = SubmissionViewModel(coordinator: self, pinNumber: pinNumber)
        let submissionViewController = SubmissionViewController(viewModel: submissionViewModel)
        
        navigationController?.pushViewController(submissionViewController, animated: false)
    }
    
    func popCurrentPage() {
        navigationController?.popViewController(animated: true)
    }
}
