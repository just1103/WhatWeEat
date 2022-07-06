import UIKit

protocol SettingCoordinatorDelegate: AnyObject {
    func removeFromChildCoordinators(coordinator: CoordinatorProtocol)
}

final class SettingCoordinator: CoordinatorProtocol, DislikedFoodSurveyPresentable {
    var childCoordinators = [CoordinatorProtocol]()
    var navigationController: UINavigationController?
    var type: CoordinatorType = .setting
    var settingCoordinatordelegate: SettingCoordinatorDelegate!
    var dislikedFoodSurveyCoordinatorDelegate: DislikedFoodSurveyCoordinatorDelegate! = nil
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        makeSettingPage()
    }
    
    func finish() {
        settingCoordinatordelegate.removeFromChildCoordinators(coordinator: self)
    }
    
    private func makeSettingPage() {
        let settingViewModel = SettingViewModel(coordinator: self)
        let settingViewController = SettingViewController(viewModel: settingViewModel)

        navigationController?.pushViewController(settingViewController, animated: true)
    }
    
    func showDislikedFoodSurveyPage() {
        let dislikedFoodSurveyViewModel = DislikedFoodSurveyViewModel(coordinator: self)
        let dislikedFoodSurveyViewController = DislikedFoodSurveyViewController(viewModel: dislikedFoodSurveyViewModel)

        navigationController?.pushViewController(dislikedFoodSurveyViewController, animated: false)
    }
    
    func showSettingDetailPageWith(title: String, content: String) {
        let settingDetailViewModel = SettingDetailViewModel(coordinator: self)
        let settingDetailViewController = SettingDetailViewController(
            viewModel: settingDetailViewModel,
            title: title,
            content: content
        )
        
        navigationController?.pushViewController(settingDetailViewController, animated: false)
    }
    
    func popCurrentPage() {
        navigationController?.popViewController(animated: false)
    }
    
    func showAppStorePage() {
        let appID = "1632157845"
        let url = "itms-apps://itunes.apple.com/app/\(appID)"
        
        guard
            let url = URL(string: url),
            UIApplication.shared.canOpenURL(url)
        else { return }
        
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        } else {
            UIApplication.shared.openURL(url)
        }
    }
}
