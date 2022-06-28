import UIKit
import RxCocoa
import RxSwift

class NetworkErrorViewController: UIViewController {
    // MARK: - Properties
    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Design.backgroundViewColor
        return view
    }()
    private let errorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Content.errorImage
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = Design.errorImageViewTintColor
        return imageView
    }()
    private let errorTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Text.errorTitleLabelText
        label.font = Design.errorTitleLabelFont
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        label.textAlignment = .center
        return label
    }()
    private let retryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Content.retryButtonImage, for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setPreferredSymbolConfiguration(Design.retryButtonSize, forImageIn: .normal)
        button.tintColor = Design.retryButtonTintColor
        return button
    }()
    
    private var viewModel: NetworkErrorViewModel!
    
    convenience init(viewModel: NetworkErrorViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    private func configureUI() {
        view.backgroundColor = Design.backgroundColor
        view.addSubview(backgroundView)
        view.addSubview(errorImageView)
        view.addSubview(errorTitleLabel)
        view.addSubview(retryButton)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            errorTitleLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            errorTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            errorTitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            errorImageView.heightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.heightAnchor,
                multiplier: Constraint.errorImageViewHeightAnchorMultiplier
            ),
            errorImageView.widthAnchor.constraint(equalTo: errorImageView.heightAnchor),
            errorImageView.bottomAnchor.constraint(
                equalTo: errorTitleLabel.topAnchor,
                constant: Constraint.errorImageViewBottomAnchorConstant
            ),
            errorImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            retryButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            retryButton.topAnchor.constraint(equalTo: errorTitleLabel.bottomAnchor),
            retryButton.heightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.heightAnchor,
                multiplier: Constraint.retryButtonHeightAnchorMultiplier
            ),
            retryButton.widthAnchor.constraint(equalTo: retryButton.heightAnchor),
        ])
    }
}

// MARK: - Rx Binding Methods
extension NetworkErrorViewController {
    private func bind() {
        let input = NetworkErrorViewModel.Input(retryButtonDidTap: retryButton.rx.tap.asObservable())
        
        viewModel.transform(input)
    }
}

// MARK: - Namespaces
extension NetworkErrorViewController {
    private enum Design {
        static let backgroundViewColor: UIColor = .white
        static let errorImageViewTintColor: UIColor = .darkGray
        static let errorTitleLabelFont: UIFont = .pretendard(family: .medium, size: 30)
        static let retryButtonSize = UIImage.SymbolConfiguration(pointSize: 40)
        static let retryButtonTintColor: UIColor = .darkGray
        static let backgroundColor: UIColor = .systemGray6
    }
    
    private enum Constraint {
        static let errorImageViewHeightAnchorMultiplier = 0.2
        static let errorImageViewBottomAnchorConstant: CGFloat = -60
        static let retryButtonHeightAnchorMultiplier = 0.15
    }
    
    private enum Content {
        static let errorImage = UIImage(systemName: "wifi.slash")
        static let retryButtonImage = UIImage(systemName: "arrow.clockwise.circle")
    }
    
    private enum Text {
        static let errorTitleLabelText = "네트워크 연결 상태를 확인해주세요"
    }
}
