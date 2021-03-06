import UIKit

protocol DislikedFoodSurveyCoordinatorDelegate: AnyObject {
    func showMainTabBarPage()
    func removeFromChildCoordinators(coordinator: CoordinatorProtocol)
}

final class OnboardingCoordinator: CoordinatorProtocol, DislikedFoodSurveyPresentable {
    // MARK: - Properties
    weak var navigationController: UINavigationController?
    var childCoordinators = [CoordinatorProtocol]()
    var type: CoordinatorType = .onboarding
    
    weak var dislikedFoodSurveyCoordinatorDelegate: DislikedFoodSurveyCoordinatorDelegate!
    
    // MARK: - Initializers
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        makeOnboardingPage()
    }
    
    func finish() {
        dislikedFoodSurveyCoordinatorDelegate.removeFromChildCoordinators(coordinator: self)
    }
    
    func popCurrentPage() {
        navigationController?.popViewController(animated: true)
    }
    
    private func makeOnboardingPage() {
        let firstPage = OnboardingContentViewController(
            titleLabelText: Text.firstPageTitleLabelText,
            descriptionLabelText: Text.firstPageDescriptionLabelText,
            image: Content.firstPageImage
        )
        let secondPage = OnboardingContentViewController(
            titleLabelText: Text.secondPageTitleLabelText,
            descriptionLabelText: Text.secondPageDescriptionLabelText,
            image: Content.secondPageImage
        )
        
        let dislikedFoodSurveyViewModel = DislikedFoodSurveyViewModel(coordinator: self)
        let thirdPage = DislikedFoodSurveyViewController(viewModel: dislikedFoodSurveyViewModel)
        
        let onboardingPageViewModel = OnboardingViewModel()
        let onboardingPageViewController = OnboardingPageViewController(
            viewModel: onboardingPageViewModel,
            pages: [firstPage, secondPage, thirdPage]
        )
        
        navigationController?.pushViewController(onboardingPageViewController, animated: true)
    }
}

// MARK: - NameSpaces
extension OnboardingCoordinator {
    private enum Text {
        static let skipButtonTitle: String = "Skip"
        static let firstPageTitleLabelText: String = "????????? ??? ????????? ????????? ???"
        static let firstPageDescriptionLabelText: String = """
        ???????????? ???????????????,
        ?????? ????????? ?????? ??????????
        
        ?????????????????? ?????? ??????????????????.
        """
        static let secondPageTitleLabelText: String = "????????? ?????????????"
        static let secondPageDescriptionLabelText: String = """
        9?????? ???????????? ????????? ????????????
        ????????? ????????? ????????? ????????????.
                
        ??????, ??????????????? ??????????????????.
        """
    }
    
    private enum Content { 
        static let firstPageImage: UIImage? = UIImage(named: "appIconWhiteCircle")
        static let secondPageImage: UIImage? = UIImage(named: "gameScreenshot")
    }
}
