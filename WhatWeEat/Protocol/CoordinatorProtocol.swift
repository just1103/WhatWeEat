import UIKit

enum CoordinatorType {
    case app, onboarding, tab, setting, game, home, togetherMenu, soloMenu
}

protocol CoordinatorProtocol: AnyObject {
    var childCoordinators: [CoordinatorProtocol] { get set }
    var navigationController: UINavigationController? { get set }
    var type: CoordinatorType { get }
    
    func start()
}
