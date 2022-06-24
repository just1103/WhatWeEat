import UIKit

final class MainTabBarController: UITabBarController {
    // MARK: - Properties
    private var viewModel: MainTabBarViewModel!
    private var pages: [UINavigationController]!
    
    // MARK: - Initializers
    init(viewModel: MainTabBarViewModel, pages: [UINavigationController]) {
        super.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
        self.pages = pages
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ???: UITabBarController init의 side-effect로 인해 viewDidLoad 대신 해당 위치에 배치함
        configureNavigationBar()
        configureTabBar()
        bind()
    }
    
    // MARK: - Methods
    private func configureNavigationBar() {
        let settingsImage = UIImage(systemName: "gearshape")
        let settingsButton = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = settingsButton
        navigationItem.rightBarButtonItem?.tintColor = .black
        
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.black,
                                                                   .font: UIFont.preferredFont(forTextStyle: .title1)]
        navigationItem.title = "우리뭐먹지"
        let textAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.black,
            .font: UIFont.preferredFont(forTextStyle: .title1)
        ]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        navigationItem.hidesBackButton = true
    }

    private func configureTabBar() {
        self.tabBar.tintColor = .mainOrange
        self.tabBar.unselectedItemTintColor = .systemGray
        tabBar.backgroundColor = .systemGray6
        
        viewControllers = pages
    }
}

// MARK: - TabBarController Delegate
extension MainTabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let selectedIndex = tabBar.items?.firstIndex(of: item) else { return }
        switch selectedIndex {
        case 0:
            navigationItem.title = "우리뭐먹지"
        case 1:
            navigationItem.title = "함께 메뉴 결정"
        case 2:
            navigationItem.title = "혼밥 메뉴 결정"
        default:
            navigationItem.title = "우리뭐먹지"
        }
    }
}

// MARK: - Rx Binding Methods
extension MainTabBarController {
    private func bind() {
        guard let rightBarButtonItem = navigationItem.rightBarButtonItem else { return }
        let input = MainTabBarViewModel.Input(rightBarButtonItemDidTap: rightBarButtonItem.rx.tap.asObservable())
        
        viewModel.transform(input)
    }
}
