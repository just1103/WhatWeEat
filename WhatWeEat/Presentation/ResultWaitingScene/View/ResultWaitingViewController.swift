import Lottie
import RxCocoa
import RxSwift
import UIKit

class ResultWaitingViewController: UIViewController {
    // MARK: - Properties
    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Design.backgroundViewColor
        return view
    }()
    private let pinNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = Design.pinNumberLabelTextColor
        label.font = Design.pinNumberLabelFont
        label.text = Text.pinNumberLabelText
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let loadingCircleView: AnimationView = {
        let animationView = Design.loadingCircleView
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = Design.loadingCircleViewAnimationSpeed
        return animationView
    }()
    private let submissionCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Text.submissionCountLabelText
        label.textColor = Design.submissionCountLabelTextColor
        label.textAlignment = .center
        label.font = Design.submissionCountLabelFont
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Text.descriptionLabelText
        label.textColor = Design.descriptionLabelTextColor
        label.textAlignment = .center
        label.font = Design.descriptionLabelFont
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let gameResultCheckButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Text.gameResultCheckButtonTitle, for: .normal)
        button.setTitleColor(Design.gameResultCheckButtonTitleColor, for: .normal)
        button.titleLabel?.font = Design.gameResultCheckButtonTitleFont
        button.backgroundColor = Design.gameResultCheckButtonBackgroundColor
        button.clipsToBounds = true
        button.isHidden = true
        return button
    }()
    private let gameRestartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Text.gameRestartButtonTitle, for: .normal)
        button.setTitleColor(Design.gameRestartButtonTitleColor, for: .normal)
        button.titleLabel?.font = Design.gameRestartButtonTitleFont
        button.backgroundColor = Design.gameRestartButtonBackgroundColor
        button.setImage(Content.gameRestartButtonImage, for: .normal)
        button.tintColor = Design.gameRestartButtonTintColor
        button.titleEdgeInsets = Design.gameRestartButtonTitleInsets
        button.contentHorizontalAlignment = .center
        button.clipsToBounds = true
        button.isHidden = false
        return button
    }()

    private var viewModel: ResultWaitingViewModel!
    private let invokedViewDidLoad = PublishSubject<Void>()
    private let disposeBag = DisposeBag()

    // MARK: - Initializers
    convenience init(viewModel: ResultWaitingViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureUI()
        bind()
        invokedViewDidLoad.onNext(())
    }

    // MARK: - Methods
    private func configureNavigationBar() {
        navigationItem.hidesBackButton = true
    }

    private func configureUI() {
        view.backgroundColor = .lightGray
        
        view.addSubview(backgroundView)
        view.addSubview(pinNumberLabel)
        view.addSubview(loadingCircleView)
        view.addSubview(submissionCountLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(gameResultCheckButton)
        view.addSubview(gameRestartButton)
        
        loadingCircleView.play()
        gameResultCheckButton.layer.cornerRadius = Design.gameResultCheckButtonCornerRadius
        gameRestartButton.layer.cornerRadius = Design.gameRestartButtonCornerRadius

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            pinNumberLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constraint.pinNumberLabelTopAnchorConstant
            ),
            pinNumberLabel.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: Constraint.pinNumberLabelTrailingAnchorAnchorConstant
            ),
            
            submissionCountLabel.centerXAnchor.constraint(equalTo: loadingCircleView.centerXAnchor),
            submissionCountLabel.centerYAnchor.constraint(equalTo: loadingCircleView.centerYAnchor),
            
            loadingCircleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingCircleView.topAnchor.constraint(
                equalTo: pinNumberLabel.bottomAnchor,
                constant: Constraint.loadingCircleViewTopAnchorConstant
            ),
            loadingCircleView.heightAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.heightAnchor,
                multiplier: Constraint.loadingCircleViewHeightAnchorMultiplier
            ),
            loadingCircleView.widthAnchor.constraint(equalTo: loadingCircleView.heightAnchor),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(
                equalTo: loadingCircleView.bottomAnchor,
                constant: Constraint.descriptionLabelTopAnchorConstant
            ),
            
            gameResultCheckButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameResultCheckButton.topAnchor.constraint(
                equalTo: descriptionLabel.bottomAnchor,
                constant: Constraint.gameResultCheckButtonTopAnchorConstant
            ),
            gameResultCheckButton.heightAnchor.constraint(equalToConstant: Constraint.gameResultCheckButtonHeightAnchorConstant),
            gameResultCheckButton.widthAnchor.constraint(equalToConstant: gameRestartButton.intrinsicContentSize.width + 80),
            
            gameRestartButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: Constraint.gameRestartButtonTrailingAnchorConstant
            ),
            gameRestartButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: Constraint.gameRestartButtonBottomAnchorConstant
            ),
            gameRestartButton.heightAnchor.constraint(equalToConstant: Constraint.gameRestartButtonHeightAnchorConstant),
            gameRestartButton.widthAnchor.constraint(equalToConstant: gameRestartButton.intrinsicContentSize.width + 50),
        ])
    }
}

// MARK: - Rx Binding Methods
extension ResultWaitingViewController {
    private func bind() {
        let input = ResultWaitingViewModel.Input(
            invokedViewDidLoad: invokedViewDidLoad.asObservable(),
            gameResultCheckButtonDidTap: gameResultCheckButton.rx.tap.asObservable(),
            gameRestartButtonDidTap: gameRestartButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input)

        configurePinNumberAndResultWaitingInformation(with: output.pinNumberAndResultWaitingInformation)
        configureUpdatedSubmissionCount(with: output.updatedSubmissionCount)
        configureUpdatedIsGameClosed(with: output.updatedIsGameClosed)
    }

    private func configurePinNumberAndResultWaitingInformation(
        with outputObservable: Observable<(String, Int, Bool, Bool)>
    ) {
        outputObservable
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (self, pinNumberAndResultWaitingInformation) in
                let (pinNumber, submissionCount, isHost, isGameClosed) = pinNumberAndResultWaitingInformation
                
                self.pinNumberLabel.text = "PIN NUMBER : \(pinNumber)"
                self.submissionCountLabel.text = "\(submissionCount)명\n제출 완료"
                
                if isHost || isGameClosed {
                    self.gameResultCheckButton.isHidden = false
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func configureUpdatedSubmissionCount(with outputObservable: Observable<Int>) {
        outputObservable
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (self, updatedSubmissionCount) in
                self.submissionCountLabel.text = "\(updatedSubmissionCount)명\n제출 완료"
            })
            .disposed(by: disposeBag)
    }
    
    private func configureUpdatedIsGameClosed(with outputObservable: Observable<Bool>) {
        outputObservable
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (self, isGameClosed) in
                if isGameClosed {
                    self.gameResultCheckButton.isHidden = false
                }
            })
            .disposed(by: disposeBag)
    }
}

extension ResultWaitingViewController {
    private enum Design {
        static let backgroundViewColor: UIColor = .mainOrange
        static let pinNumberLabelTextColor: UIColor = .white
        static let pinNumberLabelFont: UIFont = .pretendard(family: .regular, size: 15)
        static let submissionCountLabelTextColor: UIColor = .white
        static let submissionCountLabelFont: UIFont = .pretendard(family: .medium, size: 30)
        static let loadingCircleView = AnimationView(name: "loader")
        static let loadingCircleViewAnimationSpeed = 0.5
        static let descriptionLabelTextColor: UIColor = .white
        static let descriptionLabelFont: UIFont = .pretendard(family: .medium, size: 23)
        static let gameResultCheckButtonTitleColor: UIColor = .mainOrange
        static let gameResultCheckButtonTitleFont: UIFont = .pretendard(family: .medium, size: 25)
        static let gameResultCheckButtonBackgroundColor: UIColor = .white
        static let gameRestartButtonTitleColor: UIColor = .darkGray
        static let gameRestartButtonTitleFont: UIFont = .pretendard(family: .medium, size: 20)
        static let gameRestartButtonBackgroundColor: UIColor = .white
        static let gameRestartButtonTintColor: UIColor = .darkGray
        static let gameRestartButtonTitleInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10)
        static let gameResultCheckButtonCornerRadius: CGFloat = UIScreen.main.bounds.height * 0.08 * 0.5
        static let gameRestartButtonCornerRadius: CGFloat = UIScreen.main.bounds.height * 0.06 * 0.5
    }
    
    private enum Constraint {
        static let pinNumberLabelTopAnchorConstant: CGFloat = 15
        static let pinNumberLabelTrailingAnchorAnchorConstant: CGFloat = -15
        static let loadingCircleViewTopAnchorConstant: CGFloat = UIScreen.main.bounds.height * 0.01
        static let loadingCircleViewHeightAnchorMultiplier = 0.45
        static let descriptionLabelTopAnchorConstant: CGFloat = UIScreen.main.bounds.height * 0.02
        static let gameResultCheckButtonTopAnchorConstant: CGFloat = UIScreen.main.bounds.height * 0.03
        static let gameResultCheckButtonHeightAnchorConstant: CGFloat = UIScreen.main.bounds.height * 0.08
        static let gameRestartButtonTrailingAnchorConstant: CGFloat = -15
        static let gameRestartButtonBottomAnchorConstant: CGFloat = -15
        static let gameRestartButtonHeightAnchorConstant: CGFloat = UIScreen.main.bounds.height * 0.06
    }
    
    private enum Content {
        static let gameRestartButtonImage = UIImage(systemName: "arrow.counterclockwise.circle")
    }
    
    private enum Text {
        static let pinNumberLabelText = "PIN NUMBER : "
        static let submissionCountLabelText = "1명\n제출 완료"
        static let descriptionLabelText = """
        팀원들을 기다리고 있어요

        Host가 결과확인 버튼을 누르면
        오늘의 메뉴가 결정됩니다
        """
        static let gameResultCheckButtonTitle = "결과 확인하기"
        static let gameRestartButtonTitle = "게임 다시 시작"
    }
}
