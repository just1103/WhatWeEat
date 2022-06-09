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
    
    func showDislikedFoodSurveyPage() {
        let dislikedFoodSurveyViewModel = DislikedFoodSurveyViewModel(coordinator: self)
        let dislikedFoodSurveyViewController = DislikedFoodSurveyViewController(viewModel: dislikedFoodSurveyViewModel)

        navigationController?.pushViewController(dislikedFoodSurveyViewController, animated: false)
    }
    
    func showSettingDetailPageWith(title: String, content: String) {
        let settingDetailViewModel = SettingDetailViewModel(coordinator: self)
        let settingDetailViewController = SettingDetailViewController(
            title: title,
            content: content,
            viewModel: settingDetailViewModel
        )
        
        navigationController?.pushViewController(settingDetailViewController, animated: false)
    }
    
    func popCurrentPage() {
        navigationController?.popViewController(animated: false)
    }
    
    private func makeSettingPage() {
        let settingViewModel = SettingViewModel(coordinator: self)
        let settingViewController = SettingViewController(viewModel: settingViewModel)

        navigationController?.pushViewController(settingViewController, animated: true)
    }
    
    private func showAppStorePage() {
        // TODO: 링크를 통해 APPStore 앱 연결
    }
}
