import UIKit

final class MainTabBarController: UITabBarController {
    // MARK: - Properties
    private var pages: [TapBarContentProtocol]!
    
    // MARK: - Initializers
    init(pages: [TapBarContentProtocol]) {
        super.init(nibName: nil, bundle: nil)
        self.pages = pages
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // ???: UITabBarController init의 side-effect로 인해 viewDidLoad 대신 해당 위치에 배치함
        configureNavigationBar()
        configureTabBar()
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
        navigationItem.hidesBackButton = true
    }

    private func configureTabBar() {
        self.tabBar.tintColor = ColorPalette.mainYellow
        self.tabBar.unselectedItemTintColor = .systemGray
        tabBar.backgroundColor = .systemGray6
        
        viewControllers = pages as? [UIViewController]
    }
}
