import RxSwift
import UIKit

protocol MenuCoordinatorDelegate: AnyObject {
    func hideNavigationBarAndTabBar()
    func showNavigationBarAndTabBar()
    func removeFromChildCoordinatorsAndRestart(coordinator: CoordinatorProtocol)
}

final class TogetherMenuCoordinator: CoordinatorProtocol {
    var childCoordinators: [CoordinatorProtocol] = []
    var navigationController: UINavigationController?
    var type: CoordinatorType = .togetherMenu
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
    
    func showEnterWithPinNumberPage() {
        let enterWithPinNumberViewModel = EnterWithPinNumberViewModel(coordinator: self)
        let enterWithPinNumberViewController = EnterWithPinNumberViewController(viewModel: enterWithPinNumberViewModel)
        
        navigationController?.pushViewController(enterWithPinNumberViewController, animated: false)
    }
    
    func showGamePage(with pinNumber: String? = nil) {
        guard let navigationController = navigationController else { return }
        let gameCoordinator = GameCoordinator(navigationController: navigationController, pinNumber: pinNumber)
        gameCoordinator.delegate = self
        childCoordinators.append(gameCoordinator)
        gameCoordinator.start()
    }
    
    func showLatestSubmissionPage(pinNumber: String, token: String) {
        guard let navigationController = navigationController else { return }
        let gameCoordinator = GameCoordinator(navigationController: navigationController, pinNumber: pinNumber)
        gameCoordinator.delegate = self
        childCoordinators.append(gameCoordinator)
        gameCoordinator.showSubmissionPage(pinNumber: pinNumber, token: token)
    }
    
    func popCurrentPage() {
        navigationController?.popViewController(animated: false)
    }
}

extension TogetherMenuCoordinator: TogetherGameCoordinatorDelegate {
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

    // 게임 재시작 버튼
    // TODO: together-C는 유지한 채로
    // 초기화면으로 돌아가게만 해주면 되려나?
    func showInitialTogetherMenuPage() {
        delegate.removeFromChildCoordinatorsAndRestart(coordinator: self)
        
        let togetherMenuViewModel = TogetherMenuViewModel(coordinator: self)
        let togetherMenuViewController = TogetherMenuViewController(viewModel: togetherMenuViewModel)
        
        // FIXME: 화면에서 사라진 SharePinNumberPage를 navigationController.viewControllers에서 빼줬는데 메모리에 살아있음
        navigationController?.viewControllers = [togetherMenuViewController]
    }
}
