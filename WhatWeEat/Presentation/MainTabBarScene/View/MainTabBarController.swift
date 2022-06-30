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
        changeNavigationTitle(selectedIndex: selectedIndex)
    }
    
    // MARK: - Methods
    private func configureNavigationBar() {
        let settingsImage = Content.settingImage
        let settingsButton = UIBarButtonItem(image: settingsImage, style: .plain, target: self, action: nil)
        navigationItem.rightBarButtonItem = settingsButton
        navigationItem.rightBarButtonItem?.tintColor = Design.navigationRightBarButtonTintColor
        
        navigationItem.title = Text.navigationTitle
        navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Design.navigationTitleColor,
            .font: Design.navigationTitleFont,
        ]
        
        navigationItem.hidesBackButton = true
    }

    private func configureTabBar() {
        self.tabBar.tintColor = Design.tabBarTintColor
        self.tabBar.unselectedItemTintColor = Design.tabBarUnselectedTintColor
        tabBar.backgroundColor = Design.tabBarBackgroundColor
        
        viewControllers = pages
    }
    
    private func changeNavigationTitle(selectedIndex: Int) {
        switch selectedIndex {
        case 0:
            navigationItem.title = Text.homeNavigationTitle
        case 1:
            navigationItem.title = Text.togetherNavigationTitle
        case 2:
            navigationItem.title = Text.soloNavigationTitle
        default:
            navigationItem.title = Text.homeNavigationTitle
        }
    }
}

// MARK: - TabBarController Delegate
extension MainTabBarController: UITabBarControllerDelegate {
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        guard let selectedIndex = tabBar.items?.firstIndex(of: item) else { return }
        changeNavigationTitle(selectedIndex: selectedIndex)
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

// MARK: - Namespaces
extension MainTabBarController {
    private enum Design {
        static let navigationTitleFont: UIFont = .pretendard(family: .medium, size: 25)
        static let navigationTitleColor: UIColor = .black
        static let navigationRightBarButtonTintColor: UIColor = .black
        static let tabBarTintColor: UIColor = .mainOrange
        static let tabBarUnselectedTintColor: UIColor = .systemGray
        static let tabBarBackgroundColor: UIColor = .systemGray6
        
    }
    
    private enum Content {
        static let settingImage = UIImage(systemName: "gearshape")
    }
    
    private enum Text {
        static let navigationTitle = "우리뭐먹지"
        static let homeNavigationTitle = "우리뭐먹지"
        static let togetherNavigationTitle = "함께 메뉴 결정"
        static let soloNavigationTitle = "혼밥 메뉴 결정"
    }
}
