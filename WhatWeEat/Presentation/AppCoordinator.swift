import RxSwift
import UIKit

final class AppCoordinator: CoordinatorProtocol, DislikedFoodSurveyCoordinatorDelegate {
    // MARK: - Properties
    weak var navigationController: UINavigationController?
    var childCoordinators = [CoordinatorProtocol]()
    var type: CoordinatorType = .app
    
    // MARK: - Initializers
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    func start() {
        // TODO: 초기화면에서 인터넷 연결안되어 있으면 View 띄워줌
        if FirstLaunchChecker.isFirstLaunched() {
            showOnboardingPage()
        } else {
            showMainTabBarPage()
        }
    }
    
    private func showOnboardingPage() {
        guard let navigationController = navigationController else { return }
        let onboardingCoordinator = OnboardingCoordinator(navigationController: navigationController)
        onboardingCoordinator.dislikedFoodSurveyCoordinatorDelegate = self 
        
        childCoordinators.append(onboardingCoordinator)
        onboardingCoordinator.start()
    }
    
    func showMainTabBarPage() {
        guard let navigationController = navigationController else { return }
        let mainTabBarCoordinator = MainTabBarCoordinator(navigationController: navigationController)
        
        childCoordinators.append(mainTabBarCoordinator)
        mainTabBarCoordinator.start()
    }
    
    func removeFromChildCoordinators(coordinator: CoordinatorProtocol) {
        let updatedChildCoordinators = childCoordinators.filter { $0 !== coordinator }
        childCoordinators = updatedChildCoordinators
    }
}

// MARK: - NameSpaces
extension AppCoordinator {
    private enum Content {
     
    }
}
