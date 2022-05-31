import RxSwift
import UIKit

final class FlowCoordinator {
    // MARK: - Properties
    weak private var navigationController: UINavigationController?
    private var onboardingPageViewController: OnboardingPageViewController!
    private var onboardingPageViewModel: OnboardingViewModel!
    private var onboardingContentViewController: OnboardingContentViewController!
    private var dislikedFoodSurveyViewController: DislikedFoodSurveyViewController!
    private var dislikedFoodSurveyViewModel: DislikedFoodSurveyViewModel!
    
    private var mainTabBarController: MainTabBarController!
    private var homeViewController: HomeViewController!
    
    // MARK: - Initializers
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    // MARK: - Methods
    func start() {
        if FirstLaunchChecker.isFirstLaunched() {
            showOnboardingPage()
        } else {
            showMainTabBarPage()
        }
    }
    
    private func showOnboardingPage() {
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
        
        let actions = DislikedFoodSurveyViewModelAction(showMainTapBarPage: showMainTabBarPage)
        let dislikedFoodSurveyViewModel = DislikedFoodSurveyViewModel(actions: actions)
        let thirdPage = DislikedFoodSurveyViewController(viewModel: dislikedFoodSurveyViewModel)
        
        let onboardingPageViewModel = OnboardingViewModel()
        let onboardingPageViewController = OnboardingPageViewController(
            viewModel: onboardingPageViewModel,
            pages: [firstPage, secondPage, thirdPage]
        )
        
        navigationController?.pushViewController(onboardingPageViewController, animated: true)
    }

    private func showMainTabBarPage() {
        let homeViewModel = HomeViewModel()
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        let togetherMenuViewModelactions = TogetherMenuViewModelAction(showSharePinNumberPage: showSharePinNumberPage)
        let togetherMenuViewModel = TogetherMenuViewModel(actions: togetherMenuViewModelactions)
        let togetherMenuViewController = TogetherMenuViewController(viewModel: togetherMenuViewModel)
        let soloMenuViewController = SoloMenuViewController()
        
        let mainTabBarViewModelAction = MainTabBarViewModelAction(showSettingPage: showSettingPage)
        let mainTabBarViewModel = MainTabBarViewModel(actions: mainTabBarViewModelAction)
        let mainTabBarController = MainTabBarController(
            pages: [homeViewController, togetherMenuViewController, soloMenuViewController],
            viewModel: mainTabBarViewModel
        )
        
        navigationController?.pushViewController(mainTabBarController, animated: true)
    }
    
    private func showSharePinNumberPage(with pinNumber: Observable<Data>) {
        let sharePinNumberPageViewModel = SharePinNumberPageViewModel(pinNumberData: pinNumber)
        let sharePinNumberPageViewController = SharePinNumberPageViewController(viewModel: sharePinNumberPageViewModel)
        
        navigationController?.pushViewController(sharePinNumberPageViewController, animated: false)
    }
    
    private func showSettingPage() {
        let settingViewModel = SettingViewModel()
        let settingViewController = SettingViewController(viewModel: settingViewModel)
        
        navigationController?.pushViewController(settingViewController, animated: true)
    }
}

// MARK: - NameSpaces
extension FlowCoordinator {
    private enum Content {
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
