import UIKit
import RxSwift

final class HomeViewController: UIViewController, TabBarContentProtocol {
    // MARK: - Properties
    private let randomMenuImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
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
        label.font = Design.menuNameLabelNormalFont
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
    // TODO: 다음 배포버전에서 구현 예정
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
    
    private lazy var constraintsForNormalMenuNameLayout: [NSLayoutConstraint] = setupConstraintsForNormalMenuNameLayout()
    private lazy var constraintsForLongMenuNameLayout: [NSLayoutConstraint] = setupConstraintsForLongMenuNameLayout()
    
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
                constant: Constraint.menuNameLabelTopAnchorConstant
            ),
            menuNameLabel.leadingAnchor.constraint(equalTo: randomDescriptionLabel.leadingAnchor),
                
            menuNameUnderline.widthAnchor.constraint(equalTo: menuNameLabel.widthAnchor),
            menuNameUnderline.heightAnchor.constraint(
                equalToConstant: Constraint.menuNameUnderlineHeightAnchorConstant
            ),
            menuNameUnderline.leadingAnchor.constraint(equalTo: menuNameLabel.leadingAnchor),
            menuNameUnderline.topAnchor.constraint(equalTo: menuNameLabel.bottomAnchor),
            
//            restaurantLocationButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.05),
        ])
        
        NSLayoutConstraint.activate(constraintsForNormalMenuNameLayout)
    }
    
    private func setupConstraintsForNormalMenuNameLayout() -> [NSLayoutConstraint] {
        let constraints = [
            menuNameDescriptionLabel.leadingAnchor.constraint(
                equalTo: menuNameLabel.trailingAnchor,
                constant: Constraint.menuNameDescriptionLabelLeadingAnchorConstant
            ),
            menuNameDescriptionLabel.bottomAnchor.constraint(equalTo: menuNameLabel.bottomAnchor),
        ]
        
        return constraints
    }

    private func setupConstraintsForLongMenuNameLayout() -> [NSLayoutConstraint] {
        let constraints = [
            menuNameDescriptionLabel.leadingAnchor.constraint(equalTo: randomDescriptionLabel.leadingAnchor),
            menuNameDescriptionLabel.topAnchor.constraint(
                equalTo: menuNameLabel.bottomAnchor,
                constant: Constraint.menuNameDescriptionLabelTopAnchorConstant
            ),
        ]
        
        return constraints
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
                        
                        if randomMenu.name.count >= 10 {
                            NSLayoutConstraint.deactivate(self.constraintsForNormalMenuNameLayout)
                            NSLayoutConstraint.activate(self.constraintsForLongMenuNameLayout)
                            self.menuNameLabel.font = Design.menuNameLabelLongFont
                        } else if randomMenu.name.count >= 6 {
                            NSLayoutConstraint.deactivate(self.constraintsForNormalMenuNameLayout)
                            NSLayoutConstraint.activate(self.constraintsForLongMenuNameLayout)
                            self.menuNameLabel.font = Design.menuNameLabelNormalFont
                        } else {
                            NSLayoutConstraint.deactivate(self.constraintsForLongMenuNameLayout)
                            NSLayoutConstraint.activate(self.constraintsForNormalMenuNameLayout)
                            self.menuNameLabel.font = Design.menuNameLabelNormalFont
                        }
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
        static let menuNameLabelNormalFont: UIFont = .pretendard(family: .bold, size: 45)
        static let menuNameLabelLongFont: UIFont = .pretendard(family: .bold, size: 39)
        static let menuNameLabelTextColor: UIColor = .mainOrange
        static let menuNameUnderlineBackgroundColor: UIColor = .mainOrange
        static let menuNameDescriptionLabelFont: UIFont = .pretendard(family: .bold, size: 35)
        static let menuNameDescriptionLabelTextColor: UIColor = .white
        static let tabBarTitleFont: UIFont = UIFont.pretendard(family: .medium, size: 12)
        static let backgroundColor: UIColor = .lightGray
    }
    
    private enum Constraint {
        static let randomDescriptionLabelTopAnchorConstant: CGFloat = UIScreen.main.bounds.height * 0.1
        static let randomDescriptionLabelLeadingAnchorConstant: CGFloat = 20
        static let todayLunchDescriptionLabelTopAnchorConstant: CGFloat = 30
        static let menuNameLabelTopAnchorConstant: CGFloat = 5
        static let menuNameUnderlineHeightAnchorConstant: CGFloat = 2
        static let menuNameDescriptionLabelLeadingAnchorConstant: CGFloat = 10
        static let menuNameDescriptionLabelTopAnchorConstant: CGFloat = 15
    }
    
    private enum Content {
        static let randomMenuImage = UIImage(named: "cheers")
        static let tabBarImage = UIImage(systemName: "house")
        static let tabBarSelectedImage = UIImage(systemName: "house.fill")
    }
    
    private enum Text {
        static let randomDescriptionLabelText = "랜덤으로 골라봤어요"
        static let todayLunchDescriptionLabelText = "오늘 식사는"
        static let menuNameLabelText = "로딩중"
        static let menuNameDescriptionLabelText = "어때요?"
        static let tapBarTitle = "Home"
    }
}
