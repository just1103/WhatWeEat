import UIKit
import RxSwift

final class OnboardingPageViewController: UIPageViewController {
    // MARK: - Properties
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = Design.pageControlCurrentPageIndicatorTintColor
        pageControl.pageIndicatorTintColor = Design.pageControlPageIndicatorTintColor
        pageControl.currentPage = 0
        return pageControl
    }()
    let skipButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Content.skipButtonTitle, for: .normal)
        button.setTitleColor(Design.skipAndConfirmButtonTitleColor, for: .normal)
        button.titleLabel?.font = Design.skipAndConfirmButtonTitleFont
        button.backgroundColor = Design.skipAndConfirmButtonBackgroundColor
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
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
    let thirdPage = DislikedFoodSurveyViewController()
    private var onboardingPages = [UIViewController]()
    private let currentIndexForPreviousPage = PublishSubject<Int>()
    private let currentIndexForNextPageAndPageCount = PublishSubject<(Int, Int)>()
    // TODO: Coordinator 생성 후 주입하는 방식으로 변경
    private var viewModel: OnboardingViewModel = OnboardingViewModel()
    private var viewModelOutput: OnboardingViewModel.Output?
    private let disposeBag = DisposeBag()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPages()
        configureUI()
        bind()
    }
    
    // MARK: - Methods
    private func setupPages() {
        dataSource = self
        delegate = self
        
        let pageConfiguration = [firstPage, secondPage, thirdPage] // TODO: page 변화에 대응하는 방법 고민
        onboardingPages = pageConfiguration
        guard let firstPage = onboardingPages.first else { return }
        setViewControllers([firstPage], direction: .forward, animated: true)
        pageControl.numberOfPages = onboardingPages.count
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(pageControl)
        view.addSubview(skipButton)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            
            skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            skipButton.widthAnchor.constraint(equalToConstant: skipButton.intrinsicContentSize.width + 30),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
    }
}

// MARK: - Rx Binding Methods
extension OnboardingPageViewController {
    private func bind() {
        let input = OnboardingViewModel.Input(
            currentIndexForPreviousPage: currentIndexForPreviousPage.asObservable(),
            currentIndexForNextPageAndPageCount: currentIndexForNextPageAndPageCount.asObservable()
        )
        
        viewModelOutput = viewModel.transform(input)
    }
}

// MARK: - PageViewController DataSource
extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let currentIndex = onboardingPages.firstIndex(of: viewController) else { return nil }
        var viewController: UIViewController?
        
        viewModelOutput?.previousPageIndex
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] previousIndex in
                guard let previousIndex = previousIndex else {
                    viewController = nil
                    return
                }
                viewController = self?.onboardingPages[previousIndex]
            })
            .disposed(by: disposeBag)
        
        currentIndexForPreviousPage.onNext(currentIndex)
        
        return viewController
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let currentIndex = onboardingPages.firstIndex(of: viewController) else { return nil }
        var viewController: UIViewController?
        
        viewModelOutput?.nextPageIndex
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] nextIndex in
                guard let nextIndex = nextIndex else {
                    viewController = nil
                    return
                }
                viewController = self?.onboardingPages[nextIndex]
            })
            .disposed(by: disposeBag)
        
        currentIndexForNextPageAndPageCount.onNext((currentIndex, onboardingPages.count))
        
        return viewController
    }
}

// MARK: - PageViewController Delegate
extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard let viewController = pageViewController.viewControllers?.first else { return }
        guard let currentIndex = onboardingPages.firstIndex(of: viewController) else { return }
        hideButtonIfLastPage(currentIndex)
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        willTransitionTo pendingViewControllers: [UIViewController]
    ) {
        guard let viewController = pendingViewControllers.first else { return }
        guard let currentIndex = onboardingPages.firstIndex(of: viewController) else { return }
        pageControl.currentPage = currentIndex
        hideButtonIfLastPage(currentIndex)
    }
    
    private func hideButtonIfLastPage(_ currentIndex: Int) {
        if currentIndex == onboardingPages.count - 1 {
            skipButton.isHidden = true
            pageControl.isHidden = true
        } else {
            skipButton.isHidden = false
            pageControl.isHidden = false
        }
    }
}

// MARK: - NameSpaces
extension OnboardingPageViewController {
    private enum Design {
        static let pageControlCurrentPageIndicatorTintColor: UIColor = ColorPalette.mainYellow
        static let pageControlPageIndicatorTintColor: UIColor = .systemGray
        static let skipAndConfirmButtonBackgroundColor: UIColor = ColorPalette.mainYellow
        static let skipAndConfirmButtonTitleColor: UIColor = .label
        static let skipAndConfirmButtonTitleFont: UIFont = .preferredFont(forTextStyle: .headline)
    }
    
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
