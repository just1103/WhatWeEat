import UIKit

final class HomeViewController: UIViewController, TabBarContentProtocol {
    // MARK: - Properties
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.backgroundColor = .white
        stackView.spacing = 20
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 40,
            leading: 40,
            bottom: UIScreen.main.bounds.height * 0.25,
            trailing: 40
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.text = "안녕하세요."
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = .preferredFont(forTextStyle: .title3)
        label.text = """
        랜덤으로 골라봤어요.
        오늘 점심은 000 어떠세요?
        """
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let descriptionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 5
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "fish")
        imageView.setContentHuggingPriority(.init(rawValue: 100), for: .vertical)
        return imageView
    }()
    private let restaurantLocationButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("식당 위치 보기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.contentHorizontalAlignment = .right
        return button
    }()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureUI()
    }
    
    // MARK: - Methods
    private func configureNavigationBar() {
        tabBarItem.title = "Home"
        tabBarItem.image = UIImage(systemName: "house")
        tabBarItem.selectedImage = UIImage(systemName: "house.fill")
    }
    
    private func configureUI() {
        view.backgroundColor = ColorPalette.mainYellow
        view.addSubview(containerStackView)
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(descriptionLabel)
        containerStackView.addArrangedSubview(descriptionImageView)
        containerStackView.addArrangedSubview(restaurantLocationButton)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            titleLabel.heightAnchor.constraint(equalTo: containerStackView.heightAnchor, multiplier: 0.05),
            descriptionLabel.heightAnchor.constraint(equalTo: containerStackView.heightAnchor, multiplier: 0.1),
            descriptionImageView.heightAnchor.constraint(greaterThanOrEqualTo: containerStackView.heightAnchor, multiplier: 0.2),
            restaurantLocationButton.heightAnchor.constraint(equalTo: containerStackView.heightAnchor, multiplier: 0.05),
        ])
    }
}