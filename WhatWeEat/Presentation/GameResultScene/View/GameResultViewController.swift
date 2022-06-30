import RxCocoa
import RxSwift
import UIKit

class GameResultViewController: UIViewController {
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
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    private let playerCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Text.playerCountLabelText
        label.textColor = Design.playerCountLabelTextColor
        label.textAlignment = .left
        label.font = Design.playerCountLabelFont
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let playerCountDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Text.playerCountDescriptionLabelText
        label.textColor = Design.playerCountDescriptionLabelTextColor
        label.textAlignment = .left
        label.font = Design.playerCountDescriptionLabelFont
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let keywordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Text.keywordLabelText
        label.textColor = Design.keywordLabelTextColor
        label.textAlignment = .left
        label.font = Design.keywordLabelFont
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let menuNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Text.menuNameLabelText
        label.textColor = Design.menuNameLabelTextColor
        label.textAlignment = .left
        label.font = Design.menuNameLabelFont
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let menuNameUnderline: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Design.menuNameUnderlineBackgroundColor
        return view
    }()
    private let menuImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Design.menuImageViewCornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    // TODO: 지도 SDK 추가 후 구현
//    private let restaurantCheckButton: UIButton = {
//        let button = UIButton()
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.setTitle("주변 식당 보기", for: .normal)
//        button.setTitleColor(.mainOrange, for: .normal)
//        button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
//        button.backgroundColor = .white
//        button.contentHorizontalAlignment = .center
//        button.layer.cornerRadius = 8
//        button.clipsToBounds = true
//        return button
//    }()
    private let nextMenuCheckButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Text.nextMenuCheckButtonTitle, for: .normal)
        button.setTitleColor(Design.nextMenuCheckButtonTitleColor, for: .normal)
        button.titleLabel?.font = Design.nextMenuCheckButtonTitleFont
        button.backgroundColor = Design.nextMenuCheckButtonBackgroundColor
        button.contentHorizontalAlignment = .center
        button.layer.cornerRadius = Design.nextMenuCheckButtonCornerRadius
        button.clipsToBounds = true
        return button
    }()
    private let shareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Text.shareButtonTitle, for: .normal)
        button.setTitleColor(Design.shareButtonTitleColor, for: .normal)
        button.titleLabel?.font = Design.shareButtonTitleFont
        button.backgroundColor = Design.shareButtonBackgroundColor
        button.setImage(Content.shareButtonImage, for: .normal)
        button.tintColor = Design.shareButtonTintColor
        button.titleEdgeInsets = Design.shareButtonTitleInsets
        button.contentHorizontalAlignment = .center
        button.layer.cornerRadius = Design.shareButtonCornerRadius
        button.clipsToBounds = true
        button.isHidden = false
        return button
    }()
    private let gameRestartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Text.gameRestartButtonTitle, for: .normal)
        button.setTitleColor(Design.gameRestartButtonTitleColor, for: .normal)
        button.titleLabel?.font = Design.gameRestartButtonFont
        button.backgroundColor = Design.gameRestartButtonBackgroundColor
        button.setImage(Content.gameRestartButtonImage, for: .normal)
        button.tintColor = Design.gameRestartButtonTintColor
        button.titleEdgeInsets = Design.gameRestartButtonTitleInsets
        button.contentHorizontalAlignment = .center
        button.layer.cornerRadius = Design.gameRestartButtonCornerRadius
        button.clipsToBounds = true
        button.isHidden = false
        return button
    }()
    private let loadingActivityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .large
        return activityIndicator
    }()
    
    private var viewModel: GameResultViewModel!
    private let invokedViewDidLoad = PublishSubject<Void>()
    private let disposeBag = DisposeBag()

    // MARK: - Initializers
    convenience init(viewModel: GameResultViewModel) {
        self.init()
        self.viewModel = viewModel
    }

    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureUI()
        startLoadingActivityIndicator()
        bind()
        invokedViewDidLoad.onNext(())
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    // MARK: - Methods
    private func configureNavigationBar() {
        navigationItem.hidesBackButton = true
    }

    private func configureUI() {
        view.backgroundColor = Design.backgroundColor
        
        view.addSubview(backgroundView)
        view.addSubview(pinNumberLabel)
        view.addSubview(playerCountLabel)
        view.addSubview(playerCountDescriptionLabel)
        view.addSubview(keywordLabel)
        view.addSubview(menuNameLabel)
        view.addSubview(menuNameUnderline)
        view.addSubview(loadingActivityIndicator)
        view.addSubview(menuImageView)
//        view.addSubview(restaurantCheckButton)
        view.addSubview(nextMenuCheckButton)
        view.addSubview(shareButton)
        view.addSubview(gameRestartButton)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            pinNumberLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constraint.pinNumberLabelTopAnchorConstant
            ),
            pinNumberLabel.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: Constraint.pinNumberLabelTrailingAnchorConstant
            ),
            
            playerCountLabel.bottomAnchor.constraint(
                equalTo: playerCountDescriptionLabel.bottomAnchor
            ),
            playerCountLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constraint.playerCountLabelLeadingAnchorConstant
            ),

            playerCountDescriptionLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constraint.playerCountDescriptionLabelTopAnchorConstant
            ),
            playerCountDescriptionLabel.leadingAnchor.constraint(
                equalTo: playerCountLabel.trailingAnchor,
                constant: Constraint.playerCountDescriptionLabelLeadingAnchorConstant
            ),
            
            keywordLabel.topAnchor.constraint(
                equalTo: playerCountLabel.bottomAnchor,
                constant: Constraint.keywordLabelTopAnchorConstant
            ),
            keywordLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constraint.keywordLabelLeadingAnchorConstant
            ),
            
            menuNameLabel.topAnchor.constraint(
                equalTo: keywordLabel.bottomAnchor,
                constant: Constraint.menuNameLabelTopAnchorConstant
            ),
            menuNameLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constraint.menuNameLabelLeadingAnchorConstant
            ),
            
            menuNameUnderline.topAnchor.constraint(
                equalTo: menuNameLabel.bottomAnchor,
                constant: Constraint.menuNameUnderlineTopAnchorConstant
            ),
            menuNameUnderline.leadingAnchor.constraint(
                equalTo: menuNameLabel.leadingAnchor,
                constant: Constraint.menuNameUnderlineLeadingAnchorConstant
            ),
            menuNameUnderline.widthAnchor.constraint(
                equalTo: menuNameLabel.widthAnchor,
                constant: Constraint.menuNameUnderlineWidthAnchorConstant
            ),
            menuNameUnderline.heightAnchor.constraint(
                equalToConstant: Constraint.menuNameUnderlineHeightAnchorConstant
            ),
            
            loadingActivityIndicator.topAnchor.constraint(
                equalTo: menuNameLabel.bottomAnchor,
                constant: Constraint.menuImageViewTopAnchorConstant
            ),
            loadingActivityIndicator.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constraint.menuImageViewLeadingAnchorConstant
            ),
            loadingActivityIndicator.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: Constraint.menuImageViewTrailingAnchorConstant
            ),
            loadingActivityIndicator.heightAnchor.constraint(
                greaterThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor,
                multiplier: Constraint.menuImageViewHeightAnchorMultiplier
            ),

            menuImageView.topAnchor.constraint(
                equalTo: menuNameLabel.bottomAnchor,
                constant: Constraint.menuImageViewTopAnchorConstant
            ),
            menuImageView.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constraint.menuImageViewLeadingAnchorConstant
            ),
            menuImageView.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: Constraint.menuImageViewTrailingAnchorConstant
            ),
            menuImageView.heightAnchor.constraint(
                greaterThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor,
                multiplier: Constraint.menuImageViewHeightAnchorMultiplier
            ),
            
//            restaurantCheckButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            restaurantCheckButton.bottomAnchor.constraint(equalTo: menuImageView.bottomAnchor, constant: -15),
//            restaurantCheckButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.5),
//            restaurantCheckButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.06),
            
            nextMenuCheckButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextMenuCheckButton.topAnchor.constraint(
                equalTo: menuImageView.bottomAnchor,
                constant: Constraint.nextMenuCheckButtonTopAnchorConstant
            ),
            nextMenuCheckButton.bottomAnchor.constraint(
                equalTo: shareButton.topAnchor,
                constant: Constraint.nextMenuCheckButtonBottomAnchorConstant
            ),
            nextMenuCheckButton.widthAnchor.constraint(equalToConstant: nextMenuCheckButton.intrinsicContentSize.width + 80),
            nextMenuCheckButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.055),

            shareButton.bottomAnchor.constraint(
                equalTo: gameRestartButton.topAnchor,
                constant: Constraint.shareButtonBottomAnchorConstant
            ),
            shareButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: Constraint.shareButtonTrailingAnchorConstant
            ),
            shareButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.5),
            shareButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.04),

            gameRestartButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: Constraint.gameRestartButtonBottomAnchorConstant
            ),
            gameRestartButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: Constraint.gameRestartButtonTrailingAnchorConstant
            ),
            gameRestartButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.5),
            gameRestartButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.04),
        ])
    }
    
    private func startLoadingActivityIndicator() {
        loadingActivityIndicator.startAnimating()
    }
}

// MARK: - Rx Binding Methods
extension GameResultViewController {
    private func bind() {
        let input = GameResultViewModel.Input(
            invokedViewDidLoad: invokedViewDidLoad.asObservable(),
//            restaurantCheckButtonDidTap: restaurantCheckButton.rx.tap.asObservable(),
            nextMenuCheckButtonDidTap: nextMenuCheckButton.rx.tap.asObservable(),
            shareButtonDidTap: shareButton.rx.tap.asObservable(),
            gameRestartButtonDidTap: gameRestartButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input)

        configureContents(with: output.firstMenuAndPlayerCountAndPinNumber)
        configureNextMenuContents(with: output.nextMenu)
        configureShareButtonDidTap(with: output.shareButtonDidTap)
    }

    private func configureContents(with outputObservable: Observable<(Menu, Int, String?)>) {
        outputObservable
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (self, menusAndPlayerCountAndPinNumber) in
                let (menu, playerCount, pinNumber) = menusAndPlayerCountAndPinNumber
                
                self.configureLabels(menu: menu, playerCount: playerCount, pinNumber: pinNumber)
                self.configureImage(menu: menu)
            })
            .disposed(by: disposeBag)
    }
 
    private func configureLabels(menu: Menu, playerCount: Int, pinNumber: String?) {
        if let pinNumber = pinNumber {
            self.pinNumberLabel.text = "PIN NUMBER : \(pinNumber)"
        } else {
            self.pinNumberLabel.isHidden = true
        }
        
        if playerCount == 1 {
            self.playerCountLabel.isHidden = true
            self.playerCountLabel.text = ""
            self.playerCountDescriptionLabel.text = "오늘의 메뉴는"
        } else {
            self.playerCountLabel.text = "\(playerCount)명"
        }
        
        var keywordsText = ""
        menu.keywords?.forEach { keyword in
            keywordsText += "#\(keyword) "
        }
        
        self.keywordLabel.text = keywordsText
        self.menuNameLabel.text = menu.name
    }

    private func configureImage(menu: Menu) {
        DispatchQueue.global().async {
            guard
                let menuImageURL = menu.imageURL,
                let imageURL = URL(string: menuImageURL),
                let imageData = try? Data(contentsOf: imageURL),
                let loadedImage = UIImage(data: imageData)
            else { return }
            
            DispatchQueue.main.async {
                self.loadingActivityIndicator.stopAnimating()
                self.menuImageView.image = loadedImage
            }
        }
    }
    
    private func configureNextMenuContents(with outputObservable: Observable<(Menu?, Int)>) {
        outputObservable
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (self, nextMenuAndIndex) in
                let (nextMenu, indexOfMenu) = nextMenuAndIndex
                guard let nextMenu = nextMenu else { return }
                
                if indexOfMenu < 3 {
                    self.configureNextMenuLabels(menu: nextMenu)
                    self.configureImage(menu: nextMenu)
                    
                    self.nextMenuCheckButton.setTitle("다음 순위 메뉴 확인 (\(indexOfMenu + 1)/3)", for: .normal)
                }
            })
            .disposed(by: disposeBag)
    }
    
    private func configureNextMenuLabels(menu: Menu) {
        var keywordsText = ""
        menu.keywords?.forEach { keyword in
            keywordsText += "#\(keyword) "
        }
        
        self.keywordLabel.text = keywordsText
        self.menuNameLabel.text = menu.name
    }

    private func configureShareButtonDidTap(with outputObservable: Observable<Void>) {
        outputObservable
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                guard
                    let menuName = self.menuNameLabel.text,
                    let keywords = self.keywordLabel.text
                else { return }
                
                let title = Text.activityViewTitle
                let content = """
                [우리뭐먹지] 오늘의 메뉴는 #\(menuName) 입니다.
                팀원들이 이런 것을 원했어요. \(keywords)
                """  // 오늘의 메뉴를 맛볼 수 있는 주변 식당도 알려드려요. // TODO: 지도 SDK 추가 후 텍스트 추가
                let items = [SharePinNumberActivityItemSource(title: title, content: content)]
                
                let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
                activityViewController.popoverPresentationController?.sourceView = self.shareButton
                activityViewController.popoverPresentationController?.permittedArrowDirections = .down
                self.present(activityViewController, animated: true)
            })
            .disposed(by: disposeBag)
    }
}

extension GameResultViewController {
    private enum Design {
        static let backgroundViewColor: UIColor = .white
        static let pinNumberLabelTextColor: UIColor = .mainOrange
        static let pinNumberLabelFont: UIFont = .pretendard(family: .regular, size: 15)
        static let playerCountLabelTextColor: UIColor = .darkGray
        static let playerCountLabelFont: UIFont = .pretendard(family: .medium, size: 30)
        static let playerCountDescriptionLabelTextColor: UIColor = .darkGray
        static let playerCountDescriptionLabelFont: UIFont = .pretendard(family: .medium, size: 25)
        static let keywordLabelTextColor: UIColor = .mainOrange
        static let keywordLabelFont: UIFont = .pretendard(family: .medium, size: 25)
        static let menuNameLabelTextColor: UIColor = .mainOrange
        static let menuNameLabelFont: UIFont = .pretendard(family: .bold, size: 35)
        static let menuNameUnderlineBackgroundColor: UIColor = .mainOrange
        static let menuImageViewCornerRadius: CGFloat = 8
        static let nextMenuCheckButtonTitleColor: UIColor = .white
        static let nextMenuCheckButtonTitleFont: UIFont = .pretendard(family: .medium, size: 22)
        static let nextMenuCheckButtonBackgroundColor: UIColor = .mainOrange
        static let nextMenuCheckButtonCornerRadius: CGFloat = UIScreen.main.bounds.height * 0.055 * 0.5
        static let shareButtonTitleColor: UIColor = .mainOrange
        static let shareButtonTitleFont: UIFont = .pretendard(family: .medium, size: 20)
        static let shareButtonBackgroundColor: UIColor = .systemGray6
        static let shareButtonTintColor: UIColor = .mainOrange
        static let shareButtonTitleInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10)
        static let shareButtonCornerRadius: CGFloat = UIScreen.main.bounds.height * 0.04 * 0.5
        static let gameRestartButtonTitleColor: UIColor = .darkGray
        static let gameRestartButtonFont: UIFont = .pretendard(family: .medium, size: 20)
        static let gameRestartButtonBackgroundColor: UIColor = .systemGray6
        static let gameRestartButtonTintColor: UIColor = .darkGray
        static let gameRestartButtonTitleInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10)
        static let gameRestartButtonCornerRadius: CGFloat = UIScreen.main.bounds.height * 0.04 * 0.5
        static let backgroundColor: UIColor = .systemGray6
    }
    
    private enum Constraint {
        static let pinNumberLabelTopAnchorConstant: CGFloat = 15
        static let pinNumberLabelTrailingAnchorConstant: CGFloat = -15
        static let playerCountLabelLeadingAnchorConstant: CGFloat = 20
        static let playerCountDescriptionLabelTopAnchorConstant: CGFloat = UIScreen.main.bounds.height * 0.08
        static let playerCountDescriptionLabelLeadingAnchorConstant: CGFloat = 1
        static let keywordLabelTopAnchorConstant: CGFloat = 5
        static let keywordLabelLeadingAnchorConstant: CGFloat = 20
        static let menuNameLabelTopAnchorConstant: CGFloat = 5
        static let menuNameLabelLeadingAnchorConstant: CGFloat = 20
        static let menuNameUnderlineTopAnchorConstant: CGFloat = 2
        static let menuNameUnderlineLeadingAnchorConstant: CGFloat = 2
        static let menuNameUnderlineWidthAnchorConstant: CGFloat = 2
        static let menuNameUnderlineHeightAnchorConstant: CGFloat = 2
        static let menuImageViewTopAnchorConstant: CGFloat = UIScreen.main.bounds.height * 0.04
        static let menuImageViewLeadingAnchorConstant: CGFloat = 20
        static let menuImageViewTrailingAnchorConstant: CGFloat = -20
        static let menuImageViewHeightAnchorMultiplier: CGFloat = 0.35
        static let nextMenuCheckButtonTopAnchorConstant: CGFloat = 15
        static let nextMenuCheckButtonBottomAnchorConstant: CGFloat = -15
        static let shareButtonBottomAnchorConstant: CGFloat = -10
        static let shareButtonTrailingAnchorConstant: CGFloat = -20
        static let gameRestartButtonBottomAnchorConstant: CGFloat = -15
        static let gameRestartButtonTrailingAnchorConstant: CGFloat = -20
    }
    
    private enum Content {
        static let shareButtonImage = UIImage(systemName: "square.and.arrow.up")
        static let gameRestartButtonImage = UIImage(systemName: "arrow.counterclockwise.circle")
    }
    
    private enum Text {
        static let pinNumberLabelText = "PIN NUMBER : "
        static let playerCountLabelText = "N명"
        static let playerCountDescriptionLabelText = "이 선택한 오늘의 메뉴는"
        static let keywordLabelText = "#키워드"
        static let menuNameLabelText = "마라탕"
        static let nextMenuCheckButtonTitle = "다음 순위 메뉴 확인 (1/3)"
        static let shareButtonTitle = "공유하기"
        static let gameRestartButtonTitle = "게임 다시 시작"
        static let activityViewTitle = "[우리뭐먹지] 팀원과 오늘의 메뉴를 공유해보세요"
    }
}
