import RxCocoa
import RxSwift
import UIKit

final class SharePinNumberPageViewController: UIViewController {
    // MARK: - Properties
    private let backButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.left"), for: .normal)
        button.setTitle("다른 방법으로 게임하기", for: .normal)
        button.titleLabel?.font = .pretendard(family: .medium, size: 15)
        button.tintColor = .white
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.contentHorizontalAlignment = .leading
        return button
    }()
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.backgroundColor = .mainOrange
        stackView.spacing = 40
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: UIScreen.main.bounds.height * 0.1,
            leading: 10,
            bottom: UIScreen.main.bounds.height * 0.05,
            trailing: 10
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let pinNumberStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
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
    private let togetherImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(systemName: "person.3.fill")
        imageView.tintColor = .white
        imageView.setContentHuggingPriority(.init(100), for: .vertical)
        return imageView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .pretendard(family: .medium, size: 30)
        label.text = "팀원들에게"
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    private let pinNumberTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .pretendardDefaultSize(family: .bold)
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.text = "PIN Number"
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    private let pinNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .pretendard(family: .bold, size: 50)
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.setContentHuggingPriority(.required, for: .vertical)
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
        button.titleLabel?.font = .pretendardDefaultSize(family: .medium)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.tintColor = .mainOrange
        button.layer.cornerRadius = UIScreen.main.bounds.height * 0.06 / 2
        button.clipsToBounds = true
        button.applyShadow(direction: .bottom)
        return button
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .pretendard(family: .regular, size: 15)
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
        button.titleLabel?.font = .pretendardDefaultSize(family: .semiBold)
        button.layer.cornerRadius = UIScreen.main.bounds.height * 0.08 / 2
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
        containerStackView.addArrangedSubview(pinNumberStackView)
        containerStackView.addArrangedSubview(descriptionLabel)
        containerStackView.addArrangedSubview(gameStartButton)
        
        pinNumberStackView.addArrangedSubview(togetherImageView)
        pinNumberStackView.addArrangedSubview(titleLabel)
        pinNumberStackView.addArrangedSubview(pinNumberTitleLabel)
        pinNumberStackView.addArrangedSubview(pinNumberLabel)
        pinNumberStackView.addArrangedSubview(shareButton)
        
        NSLayoutConstraint.activate([
            backButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            backButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            backButton.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.6),
            
            containerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            togetherImageView.widthAnchor.constraint(equalTo: togetherImageView.heightAnchor),
            
            shareButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.06),
            shareButton.widthAnchor.constraint(equalToConstant: shareButton.intrinsicContentSize.width + 40),
            shareButton.centerXAnchor.constraint(equalTo: containerStackView.centerXAnchor),
            
            gameStartButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.08),
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
