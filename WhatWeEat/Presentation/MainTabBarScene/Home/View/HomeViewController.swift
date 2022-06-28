import UIKit
import RxSwift

final class HomeViewController: UIViewController, TabBarContentProtocol {
    // MARK: - Properties
    private let randomMenuImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = Content.randomMenuImage
        return imageView
    }()
    private let gradationView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.applyGradation(
            width: UIScreen.main.bounds.width,
            height: UIScreen.main.bounds.height
        )
        return view
    }()
    private let randomDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = Design.randomDescriptionLabelFont
        label.textColor = Design.randomDescriptionLabelTextColor
        label.text = Text.randomDescriptionLabelText
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let todayLunchDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = Design.todayLunchDescriptionLabelFont
        label.textColor = Design.todayLunchDescriptionLabelTextColor
        label.text = Text.todayLunchDescriptionLabelText
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let menuNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = Design.menuNameLabelFont
        label.textColor = Design.menuNameLabelTextColor
        label.text = Text.menuNameLabelText
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let menuNameUnderline: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Design.menuNameUnderlineBackgroundColor
        return view
    }()
    private let menuNameDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = Design.menuNameDescriptionLabelFont
        label.textColor = Design.menuNameDescriptionLabelTextColor
        label.text = Text.menuNameDescriptionLabelText
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    // TODO: 다음 업데이트 때 추가 예정
//    private let restaurantLocationButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("식당 위치 보기", for: .normal)
//        button.setTitleColor(.black, for: .normal)
//        button.contentHorizontalAlignment = .right
//        return button
//    }()
    
    private var viewModel: HomeViewModel!
    private let invokedViewDidLoad = PublishSubject<Void>()
    private let invokedViewWillAppear = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    convenience init(viewModel: HomeViewModel) {
        self.init()
        self.viewModel = viewModel
        configureTabBar()
    }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        bind()
        configureUI()
        invokedViewDidLoad.onNext(())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        invokedViewWillAppear.onNext(())
    }
    
    // MARK: - Methods
    private func configureTabBar() {
        tabBarItem.title = Text.tapBarTitle
        tabBarItem.image = Content.tabBarImage
        tabBarItem.selectedImage = Content.tabBarSelectedImage
        tabBarItem.setTitleTextAttributes([.font: Design.tabBarTitleFont], for: .normal)
    }
    
    private func configureUI() {
        view.backgroundColor = Design.backgroundColor
        view.addSubview(randomMenuImageView)
        view.addSubview(gradationView)
        view.addSubview(randomDescriptionLabel)
        view.addSubview(todayLunchDescriptionLabel)
        view.addSubview(menuNameLabel)
        view.addSubview(menuNameUnderline)
        view.addSubview(menuNameDescriptionLabel)

        NSLayoutConstraint.activate([
            randomMenuImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            randomMenuImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            randomMenuImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            randomMenuImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            gradationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gradationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            gradationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            gradationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            randomDescriptionLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constraint.randomDescriptionLabelTopAnchorConstant
            ),
            randomDescriptionLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constraint.randomDescriptionLabelLeadingAnchorConstant
            ),
            todayLunchDescriptionLabel.topAnchor.constraint(
                equalTo: randomDescriptionLabel.bottomAnchor,
                constant: Constraint.todayLunchDescriptionLabelTopAnchorConstant
            ),
            todayLunchDescriptionLabel.leadingAnchor.constraint(equalTo: randomDescriptionLabel.leadingAnchor),
            menuNameLabel.topAnchor.constraint(
                equalTo: todayLunchDescriptionLabel.bottomAnchor,
                constant: Constraint.todayLunchDescriptionLabelBottomAnchorConstant
            ),
            menuNameLabel.leadingAnchor.constraint(equalTo: randomDescriptionLabel.leadingAnchor),
            menuNameUnderline.widthAnchor.constraint(equalTo: menuNameLabel.widthAnchor),
            menuNameUnderline.heightAnchor.constraint(
                equalToConstant: Constraint.menuNameUnderlineHeightAnchorConstant
            ),
            menuNameUnderline.leadingAnchor.constraint(equalTo: menuNameLabel.leadingAnchor),
            menuNameUnderline.topAnchor.constraint(equalTo: menuNameLabel.bottomAnchor),
            menuNameDescriptionLabel.leadingAnchor.constraint(
                equalTo: menuNameLabel.trailingAnchor,
                constant: Constraint.menuNameDescriptionLabelLeadingAnchorConstant
            ),
            menuNameDescriptionLabel.bottomAnchor.constraint(equalTo: menuNameLabel.bottomAnchor)

//            restaurantLocationButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
        ])
    }
}

// MARK: - Rx Binding Methods
extension HomeViewController {
    private func bind() {
        let input = HomeViewModel.Input(
            invokedViewDidLoad: invokedViewDidLoad.asObservable(),
            invokedViewWillAppear: invokedViewWillAppear.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        configureRandomMenu(with: output.randomMenu)
    }
    
    private func configureRandomMenu(with outputObservable: Observable<Menu>) {
        outputObservable
            .withUnretained(self)
            .subscribe(onNext: { (self, randomMenu) in
                DispatchQueue.global().async {
                    guard let menuImageURL = randomMenu.imageURL,
                          let imageURL = URL(string: menuImageURL),
                          let imageData = try? Data(contentsOf: imageURL),
                          let loadedImage = UIImage(data: imageData)
                    else { return }
                    
                    DispatchQueue.main.async {
                        self.randomMenuImageView.image = loadedImage
                        self.menuNameLabel.text = randomMenu.name
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Namespaces
extension HomeViewController {
    private enum Design {
        static let randomDescriptionLabelFont: UIFont = .pretendard(family: .light, size: 30)
        static let randomDescriptionLabelTextColor: UIColor = .white
        static let todayLunchDescriptionLabelFont: UIFont = .pretendard(family: .bold, size: 35)
        static let todayLunchDescriptionLabelTextColor: UIColor = .white
        static let menuNameLabelFont: UIFont = .pretendard(family: .bold, size: 45)
        static let menuNameLabelTextColor: UIColor = .mainOrange
        static let menuNameUnderlineBackgroundColor: UIColor = .mainOrange
        static let menuNameDescriptionLabelFont: UIFont = .pretendard(family: .bold, size: 35)
        static let menuNameDescriptionLabelTextColor: UIColor = .white
        static let tabBarTitleFont: UIFont = UIFont.pretendard(family: .medium, size: 12)
        static let backgroundColor: UIColor = .systemGray6
    }
    
    private enum Constraint {
        static let randomDescriptionLabelTopAnchorConstant: CGFloat = UIScreen.main.bounds.height * 0.1
        static let randomDescriptionLabelLeadingAnchorConstant: CGFloat = 20
        static let todayLunchDescriptionLabelTopAnchorConstant: CGFloat = 30
        static let todayLunchDescriptionLabelBottomAnchorConstant: CGFloat = 5
        static let menuNameUnderlineHeightAnchorConstant: CGFloat = 2
        static let menuNameDescriptionLabelLeadingAnchorConstant: CGFloat = 10
    }
    
    private enum Content {
        static let randomMenuImage = UIImage(named: "cheers")
        static let tabBarImage = UIImage(systemName: "house")
        static let tabBarSelectedImage = UIImage(systemName: "house.fill")
    }
    
    private enum Text {
        static let randomDescriptionLabelText = "랜덤으로 골라봤어요"
        static let todayLunchDescriptionLabelText = "오늘 식사는"
        static let menuNameLabelText = "000"
        static let menuNameDescriptionLabelText = "어떠세요?"
        static let tapBarTitle = "Home"
    }
}
