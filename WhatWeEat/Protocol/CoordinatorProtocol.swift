import UIKit

enum CoordinatorType {
    case app, onboarding, tab
    case home, togetherMenu, soloMenu
    case setting, game
}

protocol CoordinatorProtocol: AnyObject {
    var childCoordinators: [CoordinatorProtocol] { get set }
    var navigationController: UINavigationController? { get set }
    var type: CoordinatorType { get }
    
    func start()
    func popCurrentPage()
}
