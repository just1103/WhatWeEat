import RxCocoa
import RxSwift
import UIKit

final class SharePinNumberPageViewController: UIViewController {
    // MARK: - Properties
    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.tintColor = .black
        return button
    }()
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.backgroundColor = .mainOrange
        stackView.spacing = 15
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: UIScreen.main.bounds.height * 0.1,
            leading: 10,
            bottom: UIScreen.main.bounds.height * 0.05,
            trailing: 10
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let togetherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "person.3")
        imageView.tintColor = .white
        imageView.setContentHuggingPriority(.defaultLow, for: .vertical)
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.text = "팀원들에게"
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    private let pinNumberStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        stackView.setContentHuggingPriority(.required, for: .vertical)
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 10,
            leading: 0,
            bottom: 10,
            trailing: 0
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let pinNumberTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: UIScreen.main.bounds.height * 0.05)
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.text = "PIN Number"
        return label
    }()
    private let pinNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .boldSystemFont(ofSize: UIScreen.main.bounds.height * 0.07)
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.text = " "  // 빈문자열로 할당하면 View에서 위치를 못잡음
        return label
    }()
    private let shareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("공유하기", for: .normal)
        button.setTitleColor(.mainOrange, for: .normal)
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        button.tintColor = .mainOrange
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        button.applyShadow(direction: .bottom)
        return button
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .body)
        label.text = """
        모든 팀원이 동시에 진행하지 않아도 됩니다.
        각자 편한 시간에 진행해주세요.
        """
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.textColor = .white
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    private let gameStartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("미니게임 시작", for: .normal)
        button.setTitleColor(.mainOrange, for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = .preferredFont(forTextStyle: .title1)
        button.layer.cornerRadius = 5
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
        configureNavigationBar()
        configureUI()
        bind()
    }
    
    // MARK: - Methods
    private func configureNavigationBar() {
        let backButtonImage = UIImage(systemName: "arrow.backward")
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: backButtonImage,
            style: .plain,
            target: self,
            action: nil
        )
        navigationItem.leftBarButtonItem?.tintColor = .black
    }
    
    private func configureUI() {
        // TODO: 디자인 반영하여 수정
        view.backgroundColor = .systemGray6
        view.addSubview(containerStackView)
        view.addSubview(backButton)  // FIXME: 백버튼이 Navi 뒤에
        containerStackView.addArrangedSubview(togetherImageView)
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(pinNumberStackView)
        containerStackView.addArrangedSubview(shareButton)
        containerStackView.addArrangedSubview(descriptionLabel)
        containerStackView.addArrangedSubview(gameStartButton)
        
        pinNumberStackView.addArrangedSubview(pinNumberTitleLabel)
        pinNumberStackView.addArrangedSubview(pinNumberLabel)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: -35),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            
            containerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            togetherImageView.widthAnchor.constraint(equalTo: togetherImageView.heightAnchor),
            
            shareButton.heightAnchor.constraint(lessThanOrEqualTo: containerStackView.heightAnchor, multiplier: 0.06),
            shareButton.widthAnchor.constraint(equalTo: containerStackView.heightAnchor, multiplier: 0.22),
            shareButton.centerXAnchor.constraint(equalTo: containerStackView.centerXAnchor),
            
            gameStartButton.heightAnchor.constraint(equalTo: containerStackView.heightAnchor, multiplier: 0.1),
            gameStartButton.widthAnchor.constraint(equalTo: containerStackView.widthAnchor, multiplier: 0.8),
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
    
    private func configurePinNumber(with pinNumber: Observable<String>) {
        pinNumber
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (self, pinNumberText) in
                self.pinNumberLabel.text = "\(pinNumberText)"
            })
            .disposed(by: disposeBag)
    }
    
    private func configureShareButtonDidTap(with shareButtonDidTap: Observable<Void>) {
        shareButtonDidTap
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                guard let pinNumber = self.pinNumberLabel.text else { return }
                
                let title = "[우리뭐먹지] 팀원과 PIN 번호를 공유해보세요"
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
