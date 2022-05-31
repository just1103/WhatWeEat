import UIKit

final class SoloMenuViewController: UIViewController, TabBarContentProtocol {
    // MARK: - Properties
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.backgroundColor = .white
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: UIScreen.main.bounds.height * 0.1,
            leading: 40,
            bottom: UIScreen.main.bounds.height * 0.1,
            trailing: 40
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.text = """
        장의 소리에
        귀를 귀울여주세요
        
        
        준비되셨다면
        
        """
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    private let gameStartButton: UIButton = {  // TODO: ViewModel 추가하고 화면전환 구현
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("미니게임 시작", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = ColorPalette.mainYellow
        button.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
    
    // MARK: - Initializers
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        configureTabBar()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTabBar()
        configureUI()
    }
    
    // MARK: - Methods
    private func configureTabBar() {
        tabBarItem.title = "혼밥 메뉴 결정"
        tabBarItem.image = UIImage(systemName: "person")
        tabBarItem.selectedImage = UIImage(systemName: "person.fill")
    }
    
    private func configureUI() {
        view.backgroundColor = ColorPalette.mainYellow
        view.addSubview(containerStackView)
        containerStackView.addArrangedSubview(descriptionLabel)
        containerStackView.addArrangedSubview(gameStartButton)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            descriptionLabel.heightAnchor.constraint(equalTo: containerStackView.heightAnchor, multiplier: 0.5),
            descriptionLabel.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor, constant: 40),
            descriptionLabel.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor, constant: -40),
            
            gameStartButton.heightAnchor.constraint(equalTo: containerStackView.heightAnchor, multiplier: 0.1),
            gameStartButton.widthAnchor.constraint(equalTo: containerStackView.widthAnchor, multiplier: 0.6),
        ])
    }
}
