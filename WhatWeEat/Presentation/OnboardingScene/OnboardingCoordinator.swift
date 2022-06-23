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
    
    private func makeOnboardingPage() {
        let firstPage = OnboardingContentViewController(
            titleLabelText: Content.firstPageTitleLabelText,
            descriptionLabelText: Content.firstPageDescriptionLabelText,
            image: Content.firstPageImage
        )
        let secondPage = OnboardingContentViewController(
            titleLabelText: Content.secondPageTitleLabelText,
            descriptionLabelText: Content.secondPageDescriptionLabelText,
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
    // TODO: Text로 이름 변경 (상수 텍스트를 가졌다는 전달력이 있음)
    private enum Content {  // VC이 갖고있냐 (View다, 상수이고), VM (String도 데이터다)이 갖고있냐 의견 분분
        static let skipButtonTitle: String = "Skip"
        static let firstPageTitleLabelText: String = "안녕하세요"
        static let firstPageDescriptionLabelText: String = """
        메뉴 고르다 점심시간이 사라진 경험..
        있으신가요?
        
        우리 뭐먹지는 여러분의 취향을 바탕으로
        적합한 메뉴를 추천해주는 앱입니다.
        
        혼밥 메뉴도,
        우리 팀의 회식 메뉴도 정할 수 있어요.
        """
        static let firstPageImage: UIImage? = UIImage(named: "Image")
        static let secondPageTitleLabelText: String = "메뉴 정하기"
        static let secondPageDescriptionLabelText: String = """
        각자 미니게임을 진행하면
        팀원들이 모두 만족할만한 메뉴를 추천해줍니다.
        
        혼자서도 미니게임을 할 수 있어요.
        """
        static let secondPageImage: UIImage? = UIImage(named: "Image")
    }
}
