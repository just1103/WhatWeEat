import UIKit
import RxSwift

final class OnboardingPageViewController: UIPageViewController {
    // MARK: - Properties
    private let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = Design.pageControlCurrentPageIndicatorTintColor
        pageControl.pageIndicatorTintColor = Design.pageControlPageIndicatorTintColor
        pageControl.currentPage = .zero
        pageControl.backgroundStyle = .minimal
        pageControl.allowsContinuousInteraction = false
        pageControl.isUserInteractionEnabled = false
        return pageControl
    }()
    private let arrowImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = Content.arrowImageViewImage
        return imageView
    }()
    private let skipButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [NSAttributedString.Key: Any] = [
            .font: Design.skipAndConfirmButtonTitleFont,
            .foregroundColor: Design.skipAndConfirmButtonTitleColor,
            .underlineStyle: NSUnderlineStyle.single.rawValue
        ]
        let attributedString = NSMutableAttributedString(string: Text.skipButtonTitle, attributes: attributes)
        button.setAttributedTitle(attributedString, for: .normal)
        return button
    }()

    private var viewModel: OnboardingViewModel!
    private var onboardingPages = [OnboardingContentProtocol]()
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    convenience init(viewModel: OnboardingViewModel, pages: [OnboardingContentProtocol]) {
        self.init(transitionStyle: .scroll, navigationOrientation: .horizontal)
        self.viewModel = viewModel
        self.onboardingPages = pages
    }
    
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
        
        guard let firstPage = onboardingPages.first as? UIViewController else { return }
        setViewControllers([firstPage], direction: .forward, animated: true)
        pageControl.numberOfPages = onboardingPages.count
    }
    
    private func configureUI() {
        view.backgroundColor = .white
        view.addSubview(pageControl)
        view.addSubview(arrowImageView)
        view.addSubview(skipButton)
        
        NSLayoutConstraint.activate([
            pageControl.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: Constraint.pageControlBottomAnchorConstant
            ),
            pageControl.heightAnchor.constraint(equalToConstant: Constraint.pageControlHeightAnchorConstant),
            pageControl.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: Constraint.pageControlLeadingAnchorConstant
            ),
            
            arrowImageView.centerYAnchor.constraint(equalTo: skipButton.centerYAnchor),
            arrowImageView.leadingAnchor.constraint(equalTo: pageControl.leadingAnchor),
            arrowImageView.trailingAnchor.constraint(
                equalTo: skipButton.leadingAnchor,
                constant: Constraint.arrowImageViewTrailingAnchorConstant
            ),
            arrowImageView.heightAnchor.constraint(equalToConstant: Constraint.arrowImageViewHeightAnchorConstant),
            
            skipButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: Constraint.skipButtonBottomAnchorConstant
            ),
            skipButton.widthAnchor.constraint(equalToConstant: skipButton.intrinsicContentSize.width + 30),
            skipButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: Constraint.skipButtonTrailingAnchorConstant),
        ])
    }
}

// MARK: - Rx Binding Methods
extension OnboardingPageViewController {
    private func bind() {
        let input = OnboardingViewModel.Input(skipButtonDidTap: skipButton.rx.tap.asObservable())
        
        let output = viewModel.transform(input)
        
        configureSkipButtonDidTap(with: output.skipButtonDidTap)
    }
    
    private func configureSkipButtonDidTap(with outputObservable: Observable<Void>) {
        outputObservable
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                let lastPageIndex = 2
                self.hideButtonIfLastPage(lastPageIndex)
                guard let lastPage = self.onboardingPages.last as? UIViewController else { return }
                self.setViewControllers([lastPage], direction: .forward, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - PageViewController DataSource
extension OnboardingPageViewController: UIPageViewControllerDataSource {
    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerBefore viewController: UIViewController
    ) -> UIViewController? {
        guard let onboardingPages = onboardingPages as? [UIViewController],
              let currentIndex = onboardingPages.firstIndex(of: viewController)
        else {
            return nil
        }

        return onboardingPages[safe: currentIndex - 1]
    }

    func pageViewController(
        _ pageViewController: UIPageViewController,
        viewControllerAfter viewController: UIViewController
    ) -> UIViewController? {
        guard let onboardingPages = onboardingPages as? [UIViewController],
              let currentIndex = onboardingPages.firstIndex(of: viewController)
        else {
            return nil
        }
        
        return onboardingPages[safe: currentIndex + 1]
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
        guard let viewController = pageViewController.viewControllers?.first,
              let onboardingPages = onboardingPages as? [UIViewController],
              let currentIndex = onboardingPages.firstIndex(of: viewController)
        else { return }
        
        presentButtonUnlessLastPage(currentIndex)
        pageControl.currentPage = currentIndex
    }
    
    private func presentButtonUnlessLastPage(_ currentIndex: Int) {
        if currentIndex != onboardingPages.count - 1 {
            arrowImageView.isHidden = false
            skipButton.isHidden = false
            pageControl.isHidden = false
        }
    }
        
    func pageViewController(
        _ pageViewController: UIPageViewController,
        willTransitionTo pendingViewControllers: [UIViewController]
    ) {
        guard let onboardingPages = onboardingPages as? [UIViewController],
              let viewController = pendingViewControllers.first,
              let currentIndex = onboardingPages.firstIndex(of: viewController)
        else { return }
        
        // FIXME: 살짝만 스크롤하더라도 pageControl이 바뀌는 문제 발생 -> didFinishAnimating 메서드로 옮김
//        pageControl.currentPage = currentIndex
        hideButtonIfLastPage(currentIndex)
    }
    
    private func hideButtonIfLastPage(_ currentIndex: Int) {
        if currentIndex == onboardingPages.count - 1 {
            arrowImageView.isHidden = true
            skipButton.isHidden = true
            pageControl.isHidden = true
        }
    }
}

// MARK: - Namespaces
extension OnboardingPageViewController {
    private enum Design {
        static let pageControlCurrentPageIndicatorTintColor: UIColor = .mainOrange
        static let pageControlPageIndicatorTintColor: UIColor = .systemGray
        static let skipAndConfirmButtonTitleColor: UIColor = .mainOrange
        static let skipAndConfirmButtonTitleFont: UIFont = .pretendard(family: .medium, size: 25)
    }
    
    private enum Constraint {
        static let pageControlBottomAnchorConstant: CGFloat = -UIScreen.main.bounds.height * 0.15
        static let pageControlHeightAnchorConstant: CGFloat = 20
        static let pageControlLeadingAnchorConstant: CGFloat = 20
        static let arrowImageViewTrailingAnchorConstant: CGFloat = -5
        static let arrowImageViewHeightAnchorConstant: CGFloat = 45
        static let skipButtonBottomAnchorConstant: CGFloat = -10
        static let skipButtonTrailingAnchorConstant: CGFloat = -40
    }
    
    private enum Content {
        static let arrowImageViewImage = UIImage(named: "arrow")
    }
    
    private enum Text {
        static let skipButtonTitle: String = "Skip"
    }
}
