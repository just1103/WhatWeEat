import UIKit

class OnboardingPageViewController: UIPageViewController {
    // MARK: - Properties
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = Design.pageControlCurrentPageIndicatorTintColor
        pageControl.pageIndicatorTintColor = Design.pageControlPageIndicatorTintColor
        pageControl.currentPage = 0
        return pageControl
    }()
    let skipAndConfirmButton: UIButton = {
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
    var onboardingPages = [UIViewController]()
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupPages()
        configureUI()
    }
    
    // MARK: - Methods
    private func setupPages() {
        dataSource = self
        delegate = self
        
        let pageConfiguration = [firstPage, secondPage] // TODO: page 변화에 대응하는 방법 고민
        onboardingPages = pageConfiguration
        guard let firstPage = onboardingPages.first else { return }
        setViewControllers([firstPage], direction: .forward, animated: true)
        pageControl.numberOfPages = onboardingPages.count
    }
    
    private func configureUI() {
        view.addSubview(pageControl)
        view.addSubview(skipAndConfirmButton)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            pageControl.heightAnchor.constraint(equalToConstant: 20),
            pageControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            
            skipAndConfirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10),
            skipAndConfirmButton.widthAnchor.constraint(equalToConstant: skipAndConfirmButton.intrinsicContentSize.width + 30),
            skipAndConfirmButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
        ])
    }
}

extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let currentIndex = onboardingPages.firstIndex(of: viewController) else { return nil }
        
        if currentIndex == 0 {
            return nil
        } else {
            return onboardingPages[currentIndex - 1] 
        }
    }
    
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let currentIndex = onboardingPages.firstIndex(of: viewController) else { return nil }

        if currentIndex < onboardingPages.count - 1 {
            return onboardingPages[currentIndex + 1]
        } else {
            return nil
        }
    }
}

extension OnboardingPageViewController: UIPageViewControllerDelegate {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        didFinishAnimating finished: Bool,
        previousViewControllers: [UIViewController],
        transitionCompleted completed: Bool
    ) {
        guard let viewControllers = pageViewController.viewControllers else { return }
        guard let currentIndex = onboardingPages.firstIndex(of: viewControllers[0]) else { return }
        pageControl.currentPage = currentIndex
    }
}

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
        static let confirmButtonTitle: String = "확인"
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
