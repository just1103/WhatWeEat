import UIKit
import RxSwift

final class HomeViewController: UIViewController, TabBarContentProtocol {
    // MARK: - Properties
    private let randomMenuImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.image = UIImage(named: "cheers")
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
    private let helloLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .white
        label.text = "안녕하세요."
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .white
        label.text = """
        랜덤으로 골라봤어요.
        오늘 점심은
        """
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let menuNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .mainOrange
        label.text = "000"
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let menuNameUnderline: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mainOrange
        return view
    }()
    private let menuNameDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .title1)
        label.textColor = .white
        label.text = "어떠세요?"
        label.numberOfLines = 0
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
        tabBarItem.title = "Home"
        tabBarItem.image = UIImage(systemName: "house")
        tabBarItem.selectedImage = UIImage(systemName: "house.fill")
    }
    
    private func configureUI() {
        view.backgroundColor = .systemGray6
        view.addSubview(randomMenuImageView)
        view.addSubview(gradationView)
        view.addSubview(helloLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(menuNameLabel)
        view.addSubview(menuNameUnderline)
        view.addSubview(menuNameDescriptionLabel)
//        view.addSubview(containerStackView)
//        containerStackView.addArrangedSubview(titleLabel)
//        containerStackView.addArrangedSubview(descriptionLabel)
//        containerStackView.addArrangedSubview(descriptionImageView)
//        containerStackView.addArrangedSubview(restaurantLocationButton)
        
        NSLayoutConstraint.activate([
            randomMenuImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            randomMenuImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            randomMenuImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            randomMenuImageView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            gradationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            gradationView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            gradationView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            gradationView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            helloLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: UIScreen.main.bounds.height * 0.1),
            helloLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            descriptionLabel.topAnchor.constraint(equalTo: helloLabel.bottomAnchor, constant: 15),
            descriptionLabel.leadingAnchor.constraint(equalTo: helloLabel.leadingAnchor),
            menuNameLabel.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 5),
            menuNameLabel.leadingAnchor.constraint(equalTo: helloLabel.leadingAnchor),
            menuNameUnderline.widthAnchor.constraint(equalTo: menuNameLabel.widthAnchor),
            menuNameUnderline.heightAnchor.constraint(equalToConstant: 2),
            menuNameUnderline.leadingAnchor.constraint(equalTo: menuNameLabel.leadingAnchor),
            menuNameUnderline.topAnchor.constraint(equalTo: menuNameLabel.bottomAnchor),
            menuNameDescriptionLabel.leadingAnchor.constraint(equalTo: menuNameLabel.trailingAnchor, constant: 10),
            menuNameDescriptionLabel.bottomAnchor.constraint(equalTo: menuNameLabel.bottomAnchor)
//
//            titleLabel.heightAnchor.constraint(equalTo: containerStackView.heightAnchor, multiplier: 0.05),
//            descriptionLabel.heightAnchor.constraint(equalTo: containerStackView.heightAnchor, multiplier: 0.1),
//            descriptionImageView.heightAnchor.constraint(greaterThanOrEqualTo: containerStackView.heightAnchor, multiplier: 0.2),
//            restaurantLocationButton.heightAnchor.constraint(equalTo: containerStackView.heightAnchor, multiplier: 0.05),
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
    
    private func configureRandomMenu(with randomMenu: Observable<Menu>) {
        randomMenu
            .subscribe(onNext: { [weak self] menu in
                DispatchQueue.global().async {
                    guard let menuImageURL = menu.imageURL,
                          let imageURL = URL(string: menuImageURL),
                          let imageData = try? Data(contentsOf: imageURL),
                          let loadedImage = UIImage(data: imageData)
                    else { return }
                    
                    DispatchQueue.main.async {
                        self?.randomMenuImageView.image = loadedImage
                        self?.menuNameLabel.text = menu.name
                    }
                }
            })
            .disposed(by: disposeBag)
    }
}
