import UIKit

final class OnboardingContentViewController: UIViewController, OnboardingContentProtocol {
    // MARK: - Properties
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 20
        return stackView
    }()
    private let descriptionImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = Design.imageCornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.titleLabelFont
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.descriptionLabelFont
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Initializers
    init(titleLabelText: String, descriptionLabelText: String, image: UIImage?) {
        super.init(nibName: nil, bundle: nil)
        self.titleLabel.text = titleLabelText
        self.descriptionLabel.text = descriptionLabelText
        
        guard let image = image else {
            self.descriptionImageView.isHidden = true
            return
        }
        self.descriptionImageView.image = image
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    private func configureUI () {
        view.addSubview(containerStackView)
        containerStackView.addArrangedSubview(descriptionImageView)
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(descriptionLabel)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: view.topAnchor, constant: UIScreen.main.bounds.height * 0.15),
            containerStackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            containerStackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            descriptionImageView.heightAnchor.constraint(greaterThanOrEqualToConstant: UIScreen.main.bounds.height * 0.25),
            descriptionImageView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor),
        ])
    }
}

// MARK: - NameSpaces
extension OnboardingContentViewController {
    private enum Design {
        static let titleLabelFont: UIFont = .pretendard(family: .medium, size: 30)
        static let descriptionLabelFont: UIFont = .pretendard(family: .regular, size: 20)
        static let imageCornerRadius: CGFloat = 5
    }
}
