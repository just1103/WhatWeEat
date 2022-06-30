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
        static let firstPageTitleLabelText: String = "다같이 뭐 먹을지 고민될 때"
        static let firstPageDescriptionLabelText: String = """
        아무거나 괜찮다는데,
        막상 고르면 그건 싫다죠?
        
        우리뭐먹지가 대신 골라드릴게요
        """
        static let secondPageTitleLabelText: String = "당신의 먹취향은?"
        static let secondPageDescriptionLabelText: String = """
        9가지 질문으로 취향을 분석해서
        모두가 만족할 메뉴를 알아내요
                
        물론, 혼밥메뉴도 추천해드려요
        """
//        누구든 PIN 번호로
//        간단히 참여할 수 있어요
    }
    
    private enum Content { 
        static let firstPageImage: UIImage? = UIImage(named: "appIconWhite")
        static let secondPageImage: UIImage? = UIImage(named: "image")
    }
}
