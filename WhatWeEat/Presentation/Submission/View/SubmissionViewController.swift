import RxCocoa
import RxSwift
import UIKit

class SubmissionViewController: UIViewController {
    // MARK: - Properties
    private let pinNumberLabel: UILabel = {  // TODO: 탭바버튼 종류에 따라 isHidden 처리
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        label.font = .preferredFont(forTextStyle: .body)
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
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        return label
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
        label.font = .preferredFont(forTextStyle: .title1)
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let gameResultCheckButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("결과 확인하기", for: .normal)
        button.setTitleColor(ColorPalette.mainOrange, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title1)
        button.backgroundColor = .white
        button.clipsToBounds = true
        button.isHidden = false  // TODO: default는 true, Host가 맞으면 false로 변경
        return button
    }()
    private let gameRestartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("게임 다시 시작", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
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

    private var viewModel: SubmissionViewModel!
    private let invokedViewDidLoad = PublishSubject<Void>()
    private let disposeBag = DisposeBag()

    // MARK: - Initializers
    convenience init(viewModel: SubmissionViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        showTabBar()
        configureUI()
        bind()
        invokedViewDidLoad.onNext(())
    }

    // MARK: - Methods
    private func configureNavigationBar() {
        navigationItem.hidesBackButton = true
    }
    
    private func showTabBar() {
        guard let mainTabBarController = self.navigationController?.viewControllers.first as? MainTabBarController else {
            return
        }
        
        mainTabBarController.showTabBar()
        
//        mainTabBarController.view.isHidde?n = false
//        tabBarController?.hidesBottomBarWhenPushed = false  // FIXME: 탭바 안보임; 탭바컨드롤러 밖에서 받아와야하나...?
    }

    private func configureUI() {
        view.backgroundColor = ColorPalette.mainOrange

        view.addSubview(pinNumberLabel)
        view.addSubview(submissionCountLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(gameResultCheckButton)
        view.addSubview(gameRestartButton)
        
        gameResultCheckButton.layer.cornerRadius = view.bounds.height * 0.1 * 0.5
        gameRestartButton.layer.cornerRadius = view.bounds.height * 0.07 * 0.5

        NSLayoutConstraint.activate([
            pinNumberLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            pinNumberLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            submissionCountLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            submissionCountLabel.topAnchor.constraint(equalTo: pinNumberLabel.bottomAnchor, constant: 100),
            
            descriptionLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            descriptionLabel.topAnchor.constraint(equalTo: submissionCountLabel.bottomAnchor, constant: 50),
            
            gameResultCheckButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            gameResultCheckButton.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 30),
            gameResultCheckButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.1),
            gameResultCheckButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.5),
            
            gameRestartButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            gameRestartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            gameRestartButton.heightAnchor.constraint(equalToConstant: view.bounds.height * 0.07),
            gameRestartButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.5),
        ])
    }
}

// MARK: - Rx Binding Methods
extension SubmissionViewController {
    private func bind() {
        let input = SubmissionViewModel.Input(
            invokedViewDidLoad: invokedViewDidLoad.asObservable(),
            gameResultCheckButtonDidTap: gameResultCheckButton.rx.tap.asObservable(),
            gameRestartButtonDidTap: gameRestartButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input)

        configurePinNumberAndSubmissionCount(with: output.pinNumberAndSubmissionCount)
        configureUpdatedSubmissionCount(with: output.updatedSubmissionCount)
    }

    private func configurePinNumberAndSubmissionCount(with inputObservable: Observable<(String, Int)>) {
        inputObservable
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (self, pinNumberAndSubmissionCount) in
                let (pinNumber, submissionCount) = pinNumberAndSubmissionCount
                
                self.pinNumberLabel.text = "PIN NUMBER : \(pinNumber)"
                self.submissionCountLabel.text = "\(submissionCount)명\n제출완료"
            })
            .disposed(by: disposeBag)
    }
    
    private func configureUpdatedSubmissionCount(with inputObservable: Observable<Int>) {
        inputObservable
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (self, updatedSubmissionCount) in
                self.submissionCountLabel.text = "\(updatedSubmissionCount)명\n제출완료"
            })
            .disposed(by: disposeBag)
    }
}

extension SubmissionViewController {
    private enum Design {
        static let previousQuestionButtonTitleColor: UIColor = .label
        static let skipAndConfirmButtonBackgroundColor: UIColor = ColorPalette.mainYellow
        static let skipAndConfirmButtonTitleColor: UIColor = .label
        static let skipAndConfirmButtonTitleFont: UIFont = .preferredFont(forTextStyle: .headline)
    }
}
