import RxCocoa
import RxSwift
import UIKit

final class SharePinNumberPageViewController: UIViewController {
    // MARK: - Properties
    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(Content.backButtonImage, for: .normal)
        button.setTitle(Text.backButtonTitle, for: .normal)
        button.titleLabel?.font = Design.backButtonTitleFont
        button.tintColor = Design.backButtonTintColor
        button.titleEdgeInsets = Design.backButtonInsets
        button.contentHorizontalAlignment = .leading
        return button
    }()
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.backgroundColor = Design.containerStackViewBackgroundColor
        stackView.spacing = Design.containerStackViewSpacing
        stackView.directionalLayoutMargins = Design.containerStackViewMargins
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let pinNumberStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = Design.pinNumberStackViewSpacing
        stackView.setContentHuggingPriority(.required, for: .vertical)
        stackView.directionalLayoutMargins = Design.pinNumberStackViewMargins
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let togetherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = Content.togetherImage
        imageView.tintColor = Design.togetherImageViewTintColor
        imageView.setContentHuggingPriority(.init(100), for: .vertical)
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Design.titleLabelFont
        label.text = Text.titleLabelText
        label.textColor = Design.titleLabelTextColor
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    private let pinNumberTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Design.pinNumberTitleLabelFont
        label.textColor = Design.pinNumberTitleLabelTextColor
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        label.text = Text.pinNumberTitleLabelText
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    private let pinNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Design.pinNumberLabelFont
        label.textColor = Design.pinNumberLabelTextColor
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        label.setContentHuggingPriority(.required, for: .vertical)
        label.text = Text.pinNumberLabelText
        return label
    }()
    private let shareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Text.shareButtonTitle, for: .normal)
        button.setTitleColor(.mainOrange, for: .normal)
        button.setImage(Content.shareButtonImage, for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = Design.shareButtonTitleFont
        button.titleEdgeInsets = Design.shareButtonTitleInsets
        button.tintColor = Design.shareButtonTintColor
        button.layer.cornerRadius = Design.shareButtonCornerRadius
        button.clipsToBounds = true
        button.applyShadow(direction: .bottom)
        return button
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Design.descriptionLabelFont
        label.text = Text.descriptionLabelText
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        label.textColor = Design.descriptionLabelTextColor
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    private let gameStartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Text.gameStartButtonTitle, for: .normal)
        button.setTitleColor(Design.gameStartButtonTitleColor, for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = Design.gameStartButtonTitleFont
        button.layer.cornerRadius = Design.gameStartButtonCornerRadius
        button.clipsToBounds = true
        button.applyShadow(direction: .bottom)
        return button
    }()
    
    private var viewModel: SharePinNumberPageViewModel!
    private let disposeBag = DisposeBag()
    
    // MARK: - Initializers
    convenience init(viewModel: SharePinNumberPageViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    // MARK: - Methods
    private func configureUI() {
        view.backgroundColor = Design.backgroundColor
        view.addSubview(containerStackView)
        view.addSubview(backButton)
        
        containerStackView.addArrangedSubview(pinNumberStackView)
        containerStackView.addArrangedSubview(descriptionLabel)
        containerStackView.addArrangedSubview(gameStartButton)
        
        pinNumberStackView.addArrangedSubview(togetherImageView)
        pinNumberStackView.addArrangedSubview(titleLabel)
        pinNumberStackView.addArrangedSubview(pinNumberTitleLabel)
        pinNumberStackView.addArrangedSubview(pinNumberLabel)
        pinNumberStackView.addArrangedSubview(shareButton)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constraint.backButtonTopAnchorConstant
            ),
            backButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constraint.backButtonLeadingAnchorAnchorConstant
            ),
            backButton.widthAnchor.constraint(equalToConstant: backButton.intrinsicContentSize.width + 20),
            
            containerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            togetherImageView.widthAnchor.constraint(equalTo: togetherImageView.heightAnchor),
            
            shareButton.heightAnchor.constraint(
                equalToConstant: Constraint.shareButtonHeightAnchorConstant
            ),
            shareButton.widthAnchor.constraint(equalToConstant: shareButton.intrinsicContentSize.width + 50),
            shareButton.centerXAnchor.constraint(equalTo: containerStackView.centerXAnchor),
            
            gameStartButton.heightAnchor.constraint(equalToConstant: Constraint.gameStartButtonHeightAnchorConstant),
            gameStartButton.widthAnchor.constraint(
                equalTo: containerStackView.widthAnchor,
                multiplier: Constraint.gameStartButtonWidthAnchorMultiplier
            ),
        ])
    }
}

// MARK: - Rx Binding Methods
extension SharePinNumberPageViewController {
    private func bind() {
        let input = SharePinNumberPageViewModel.Input(
            backButtonDidTap: backButton.rx.tap.asObservable(),
            shareButtonDidTap: shareButton.rx.tap.asObservable(),
            gameStartButtonDidTap: gameStartButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        configurePinNumber(with: output.pinNumber)
        configureShareButtonDidTap(with: output.shareButtonDidTap)
    }
    
    private func configurePinNumber(with outputObservable: Observable<String>) {
        outputObservable
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (self, pinNumberText) in
                self.pinNumberLabel.text = "\(pinNumberText)"
            })
            .disposed(by: disposeBag)
    }
    
    private func configureShareButtonDidTap(with outputObservable: Observable<Void>) {
        outputObservable
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                guard let pinNumber = self.pinNumberLabel.text else { return }
                
                let title = Text.activityViewTitle
                let content = """
                [우리뭐먹지] 팀원이 공유한 \(pinNumber)
                
                PIN 번호를 통해 입장하여 오늘의 메뉴를 골라보세요
                """
                let items = [SharePinNumberActivityItemSource(title: title, content: content)]
                
                let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.shareButton
                activityViewController.popoverPresentationController?.permittedArrowDirections = .down
                self.present(activityViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - Namespaces
extension SharePinNumberPageViewController {
    private enum Design {
        static let backButtonTitleFont: UIFont = .pretendard(family: .medium, size: 15)
        static let backButtonTintColor: UIColor = .white
        static let backButtonInsets = UIEdgeInsets(
            top: 0,
            left: 10,
            bottom: 0,
            right: 0
        )
        static let containerStackViewBackgroundColor: UIColor = .mainOrange
        static let containerStackViewSpacing: CGFloat = 40
        static let containerStackViewMargins = NSDirectionalEdgeInsets(
            top: UIScreen.main.bounds.height * 0.1,
            leading: 10,
            bottom: UIScreen.main.bounds.height * 0.05,
            trailing: 10
        )
        static let pinNumberStackViewSpacing: CGFloat = 5
        static let pinNumberStackViewMargins = NSDirectionalEdgeInsets(
            top: 10,
            leading: 0,
            bottom: 10,
            trailing: 0
        )
        static let togetherImageViewTintColor: UIColor = .white
        static let titleLabelTextColor: UIColor = .white
        static let titleLabelFont: UIFont = .pretendard(family: .medium, size: 30)
        static let pinNumberTitleLabelFont: UIFont = .pretendardWithDefaultSize(family: .bold)
        static let pinNumberTitleLabelTextColor: UIColor = .white
        static let pinNumberLabelFont: UIFont = .pretendard(family: .bold, size: 50)
        static let pinNumberLabelTextColor: UIColor = .white
        static let shareButtonTitleFont: UIFont = .pretendardWithDefaultSize(family: .medium)
        static let shareButtonTitleInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        static let shareButtonTintColor: UIColor = .mainOrange
        static let shareButtonCornerRadius: CGFloat = UIScreen.main.bounds.height * 0.06 * 0.5
        static let descriptionLabelFont: UIFont = .pretendard(family: .regular, size: 20)
        static let descriptionLabelTextColor: UIColor = .white
        static let gameStartButtonTitleColor: UIColor = .mainOrange
        static let gameStartButtonTitleFont: UIFont = .pretendard(family: .medium, size: 30)
        static let gameStartButtonCornerRadius: CGFloat = UIScreen.main.bounds.height * 0.08 * 0.5
        static let backgroundColor: UIColor = .systemGray6
    }
    
    private enum Constraint {
        static let backButtonTopAnchorConstant: CGFloat = 10
        static let backButtonLeadingAnchorAnchorConstant: CGFloat = 10
        static let shareButtonHeightAnchorConstant: CGFloat = UIScreen.main.bounds.height * 0.06
        static let gameStartButtonHeightAnchorConstant: CGFloat = UIScreen.main.bounds.height * 0.08
        static let gameStartButtonWidthAnchorMultiplier = 0.8
    }
    
    private enum Content {
        static let backButtonImage = UIImage(systemName: "arrow.left")
        static let togetherImage = UIImage(systemName: "person.3.fill")
        static let shareButtonImage = UIImage(systemName: "square.and.arrow.up")
    }
    
    private enum Text {
        static let backButtonTitle = "다른 방법으로 게임하기"
        static let titleLabelText = "팀원들에게"
        static let pinNumberTitleLabelText = "PIN Number"
        static let pinNumberLabelText = " " // 빈문자열은 인식 X
        static let shareButtonTitle = "공유하기"
        static let descriptionLabelText = """
        모든 팀원이 동시에 진행하지 않아도 됩니다
        각자 편한 시간에 진행해주세요
        """
        static let gameStartButtonTitle = "미니게임 시작"
        static let activityViewTitle = "[우리뭐먹지] 팀원과 PIN 번호를 공유해보세요"
    }
}
