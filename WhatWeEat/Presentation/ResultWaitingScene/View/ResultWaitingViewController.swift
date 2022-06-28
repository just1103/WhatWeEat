import Lottie
import RxCocoa
import RxSwift
import UIKit

class ResultWaitingViewController: UIViewController {
    // MARK: - Properties
    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mainOrange
        return view
    }()
    private let pinNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = .pretendard(family: .regular, size: 15)
        label.text = "PIN NUMBER : "
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let submissionCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "1명\n제출완료"
        label.textColor = .white
        label.textAlignment = .center
        label.font = .pretendard(family: .medium, size: 30)
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let loadingCircleView: AnimationView = {
        let animationView = AnimationView(name: "loader")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.animationSpeed = 0.5
        return animationView
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = """
        팀원들을 기다리고 있어요.

        Host가 결과확인 버튼을 누르면
        오늘의 메뉴가 결정됩니다.
        """
        label.textColor = .white
        label.textAlignment = .center
        label.font = .pretendard(family: .medium, size: 23)
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let gameResultCheckButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("결과 확인하기", for: .normal)
        button.setTitleColor(.mainOrange, for: .normal)
        button.titleLabel?.font = .pretendard(family: .medium, size: 25)
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.isHidden = true  // 사용자가 Host인 경우, Host가 결과확인버튼을 탭한 경우 false로 변경
        return button
    }()
    private let gameRestartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("게임 다시 시작", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = .pretendard(family: .medium, size: 20)
        button.backgroundColor = .white
        button.setImage(UIImage(systemName: "arrow.counterclockwise.circle"), for: .normal)
        button.tintColor = .darkGray
        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10)
        button.contentHorizontalAlignment = .center
        button.layer.cornerRadius = 8
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
        view.backgroundColor = .systemGray6
        
        view.addSubview(backgroundView)
        view.addSubview(pinNumberLabel)
        view.addSubview(loadingCircleView)
        view.addSubview(submissionCountLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(gameResultCheckButton)
        view.addSubview(gameRestartButton)
        
        loadingCircleView.play()
        gameResultCheckButton.layer.cornerRadius = view.bounds.height * 0.08 * 0.5
        gameRestartButton.layer.cornerRadius = view.bounds.height * 0.06 * 0.5

        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            pinNumberLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            pinNumberLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            submissionCountLabel.centerXAnchor.constraint(equalTo: loadingCircleView.centerXAnchor),
            submissionCountLabel.centerYAnchor.constraint(equalTo: loadingCircleView.centerYAnchor),
            
            loadingCircleView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loadingCircleView.topAnchor.constraint(equalTo: pinNumberLabel.bottomAnchor, constant: -15),
            loadingCircleView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.8),
            loadingCircleView.heightAnchor.constraint(equalTo: loadingCircleView.widthAnchor),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.bottomAnchor.constraint(equalTo: gameResultCheckButton.topAnchor, constant: -20),
            
            gameResultCheckButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameResultCheckButton.bottomAnchor.constraint(equalTo: gameRestartButton.topAnchor, constant: -20),
            gameResultCheckButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.08),
            gameResultCheckButton.widthAnchor.constraint(equalToConstant: gameRestartButton.intrinsicContentSize.width + 80),
            
            gameRestartButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            gameRestartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            gameRestartButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.06),
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
                self.submissionCountLabel.text = "\(submissionCount)명\n제출완료"
                
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
                self.submissionCountLabel.text = "\(updatedSubmissionCount)명\n제출완료"
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
//    private enum Design {
//        static let previousQuestionButtonTitleColor: UIColor = .label
//        static let skipAndConfirmButtonBackgroundColor: UIColor = .mainYellow
//        static let skipAndConfirmButtonTitleColor: UIColor = .label
//        static let skipAndConfirmButtonTitleFont: UIFont = .preferredFont(forTextStyle: .headline)
//    }
}
