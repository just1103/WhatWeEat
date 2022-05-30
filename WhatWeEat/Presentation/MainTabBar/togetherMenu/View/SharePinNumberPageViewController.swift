import UIKit
import RxSwift
import RxCocoa

final class SharePinNumberPageViewController: UIViewController {
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
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.text = """
        팀원들에게
        PIN 번호를 공유해주세요
        """
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    private let pinNumberStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .firstBaseline
        stackView.distribution = .fill
        stackView.spacing = 10
        return stackView
    }()
    private let pinNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title1)
        label.backgroundColor = .systemGray4
        label.text = """
        PIN Number : 111
        """
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let shareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("공유하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = ColorPalette.mainYellow
        button.titleLabel?.font = .preferredFont(forTextStyle: .title1)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
    private let startGameButton: UIButton = {
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
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title2)
        label.text = """
        모든 팀원이 동시에 진행하지 않아도 됩니다. 각자 편한 시간에 진행해주세요.
        """
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
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
        hideTabBar()
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
    
    private func hideTabBar() {
        tabBarController?.hidesBottomBarWhenPushed = true
    }
    
    private func configureUI() {
        // TODO: 디자인 반영하여 수정
        view.addSubview(containerStackView)
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(pinNumberStackView)
        containerStackView.addArrangedSubview(startGameButton)
        containerStackView.addArrangedSubview(descriptionLabel)
        
        pinNumberStackView.addArrangedSubview(pinNumberLabel)
        pinNumberStackView.addArrangedSubview(shareButton)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
        ])
    }
}

// MARK: - Rx Binding Methods
extension SharePinNumberPageViewController {
    private func bind() {
        guard let leftNavigationItem = navigationItem.leftBarButtonItem else { return }
        
        let input = SharePinNumberPageViewModel.Input(
            backButtonDidTap: leftNavigationItem.rx.tap.asObservable(),
            shareButtonDidTap: shareButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        configureBackButtonDidTap(with: output.backButtonDidTap)
        configureShareButtonDidTap(with: output.shareButtonDidTap)
    }
    
    private func configureBackButtonDidTap(with backButtonDidTap: Observable<Void>) {
        backButtonDidTap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                self?.navigationController?.popViewController(animated: false)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureShareButtonDidTap(with shareButtonDidTap: Observable<Void>) {
        shareButtonDidTap
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] in
                // TODO: ActivityView 구현
                print("ActivityView")
            })
            .disposed(by: disposeBag)
    }
}
