import UIKit

enum CoordinatorType {
    case app, onboarding, tab
    case setting, home, togetherMenu, soloMenu, game
}

protocol CoordinatorProtocol: AnyObject {
    var childCoordinators: [CoordinatorProtocol] { get set }
    var navigationController: UINavigationController? { get set }
    var type: CoordinatorType { get }
    
    func start()
}
