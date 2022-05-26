import UIKit

class FlowCoordinator {
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
        guard UserDefaults.standard.object(forKey: "isFirstLaunched") != nil else {
            showOnboardingPage()
            UserDefaults.standard.set(false, forKey: "isFirstLaunched")
            return
        }
        
        showMainTabBarPage()
    }
    
    func showOnboardingPage() {
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

    func showMainTabBarPage() {
        let homeViewController = HomeViewController()
        
//        let togetherMenuViewController = UIViewController()  // TODO: 수정
//        togetherMenuViewController.tabBarItem.title = "함께 메뉴 결정"
//        togetherMenuViewController.view.backgroundColor = .white
//        togetherMenuViewController.tabBarItem.image = UIImage(systemName: "person.3")
//        togetherMenuViewController.tabBarItem.selectedImage = UIImage(systemName: "person.3.fill")
//
//        let soloMenuViewController = UIViewController()
//        soloMenuViewController.tabBarItem.title = "혼밥 메뉴 결정"
//        soloMenuViewController.view.backgroundColor = .white
//        soloMenuViewController.tabBarItem.image = UIImage(systemName: "person")
//        soloMenuViewController.tabBarItem.selectedImage = UIImage(systemName: "person.fill")
        
        let mainTabBarController = MainTabBarController(pages: [homeViewController, homeViewController, homeViewController])
        
        navigationController?.pushViewController(mainTabBarController, animated: true)
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
