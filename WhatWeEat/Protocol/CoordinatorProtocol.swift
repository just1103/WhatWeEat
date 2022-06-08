import UIKit

enum CoordinatorType {
    case app, onboarding, tab
}

protocol CoordinatorProtocol: AnyObject {
    var childCoordinators: [CoordinatorProtocol] { get set }
    var navigationController: UINavigationController? { get set }
    var type: CoordinatorType { get }
    
    func start()
}
