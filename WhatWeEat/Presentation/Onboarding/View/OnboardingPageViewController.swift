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
        pageControl.isUserInteractionEnabled = false
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

    private var onboardingPages = [OnboardingContentProtocol]()
    private let currentIndexForPreviousPage = PublishSubject<Int>()
    private let currentIndexForNextPageAndPageCount = PublishSubject<(Int, Int)>()
    private var viewModel: OnboardingViewModel!
    private var viewModelOutput: OnboardingViewModel.Output?
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
            currentIndexForNextPageAndPageCount: currentIndexForNextPageAndPageCount.asObservable(),
            skipButtonDidTap: skipButton.rx.tap.asObservable()
        )
        
        viewModelOutput = viewModel.transform(input)
        guard let skipButtonDidTap = viewModelOutput?.skipButtonDidTap else { return }
        
        configureSkipButtonDidTap(with: skipButtonDidTap)
    }
    
    private func configureSkipButtonDidTap(with skipButtonDidTap: Observable<Void>) {
        skipButtonDidTap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] _ in
                guard let self = self else { return }
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
        var viewController: UIViewController?
        
        viewModelOutput?.previousPageIndex
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] previousIndex in
                guard let previousIndex = previousIndex else {
                    viewController = nil
                    return
                }
                viewController = self?.onboardingPages[previousIndex] as? UIViewController
            })
            .disposed(by: disposeBag)
        
        currentIndexForPreviousPage.onNext(currentIndex)
        
        return viewController
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
        var viewController: UIViewController?
        
        viewModelOutput?.nextPageIndex
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { nextIndex in
                guard let nextIndex = nextIndex else {
                    viewController = nil
                    return
                }
                viewController = onboardingPages[nextIndex]
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
        guard let viewController = pageViewController.viewControllers?.first,
              let onboardingPages = onboardingPages as? [UIViewController],
              let currentIndex = onboardingPages.firstIndex(of: viewController)
        else { return }
        
        presentButtonUnlessLastPage(currentIndex)
    }
    
    private func presentButtonUnlessLastPage(_ currentIndex: Int) {
        if currentIndex != onboardingPages.count - 1 {
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
        pageControl.currentPage = currentIndex
        hideButtonIfLastPage(currentIndex)
    }
    
    private func hideButtonIfLastPage(_ currentIndex: Int) {
        if currentIndex == onboardingPages.count - 1 {
            skipButton.isHidden = true
            pageControl.isHidden = true
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
    }
}
