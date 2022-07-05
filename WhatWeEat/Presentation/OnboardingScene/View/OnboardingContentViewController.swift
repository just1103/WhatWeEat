import UIKit

final class OnboardingContentViewController: UIViewController, OnboardingContentProtocol {
    // MARK: - Properties
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = Design.containerStackViewSpacing
        stackView.directionalLayoutMargins = Design.containerStackViewMargins
        stackView.isLayoutMarginsRelativeArrangement = true
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
        label.textColor = Design.titleLabelTextColor
        label.setContentHuggingPriority(.required, for: .vertical)
        label.setContentCompressionResistancePriority(.required, for: .vertical)
//        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = Design.descriptionLabelFont
        label.textColor = Design.descriptionLabelTextColor
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.numberOfLines = .zero
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
            containerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - Namespaces
extension OnboardingContentViewController {
    private enum Design {
        static let containerStackViewSpacing: CGFloat = 25
        static let containerStackViewMargins = NSDirectionalEdgeInsets(
            top: UIScreen.main.bounds.height * 0.02,
            leading: UIScreen.main.bounds.width * 0.05,
            bottom: UIScreen.main.bounds.width * 0.6,
            trailing: UIScreen.main.bounds.width * 0.05
        )
        static let imageCornerRadius: CGFloat = 5
        static let titleLabelFont: UIFont = .pretendard(family: .bold, size: 30)
        static let titleLabelTextColor: UIColor = .black
        static let descriptionLabelFont: UIFont = .pretendard(family: .medium, size: 22)
        static let descriptionLabelTextColor: UIColor = .black
    }
    
    private enum Constraint {
        // TODO: 레이아웃 적절한지 확인
//        static let containerStackViewTopAnchorConstant: CGFloat = UIScreen.main.bounds.height * 0.1
//        static let containerStackViewLeadingAnchorConstant: CGFloat = UIScreen.main.bounds.width * 0.03
//        static let containerStackViewTrailingAnchorConstant: CGFloat = -UIScreen.main.bounds.width * 0.03
//        static let containerStackViewHeightAnchorConstant: CGFloat = UIScreen.main.bounds.height * 0.25
    }
}
