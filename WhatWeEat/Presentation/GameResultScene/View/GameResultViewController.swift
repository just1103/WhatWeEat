import RxCocoa
import RxSwift
import UIKit

class GameResultViewController: UIViewController {
    // MARK: - Properties
    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    private let pinNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .mainOrange
        label.font = .pretendard(family: .regular, size: 15)
        label.text = "PIN NUMBER : "
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    private let playerCountLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "N명"
        label.textColor = .darkGray
        label.textAlignment = .left
        label.font = .pretendard(family: .medium, size: 30)
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let playerCountDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "이 선택한 오늘의 메뉴는"
        label.textColor = .darkGray
        label.textAlignment = .left
        label.font = .pretendard(family: .medium, size: 25)
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let keywordLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "#키워드"
        label.textColor = .mainOrange
        label.textAlignment = .left
        label.font = .pretendard(family: .medium, size: 25)
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let menuNameLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "마라탕"
        label.textColor = .mainOrange
        label.textAlignment = .left
        label.font = .pretendard(family: .bold, size: 35)
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let menuNameUnderline: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mainOrange
        return view
    }()
    private let menuImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(named: "meat")
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        return imageView
    }()
    // TODO: 지도 SDK 추가 후 추가
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
        button.setTitle("다음 순위 메뉴 확인 (1/3)", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = .pretendard(family: .medium, size: 20)
        button.backgroundColor = .mainOrange
        button.contentHorizontalAlignment = .center
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    private let shareButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("공유하기", for: .normal)
        button.setTitleColor(.mainOrange, for: .normal)
        button.titleLabel?.font = .pretendard(family: .medium, size: 20)
        button.backgroundColor = .systemGray6
        button.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        button.tintColor = .mainOrange
        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10)
        button.contentHorizontalAlignment = .center
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.isHidden = false
        return button
    }()
    private let gameRestartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("게임 다시 시작", for: .normal)
        button.setTitleColor(.darkGray, for: .normal)
        button.titleLabel?.font = .pretendard(family: .medium, size: 20)
        button.backgroundColor = .systemGray6
        button.setImage(UIImage(systemName: "arrow.counterclockwise.circle"), for: .normal)
        button.tintColor = .darkGray
        button.titleEdgeInsets = UIEdgeInsets(top: 10, left: 20, bottom: 10, right: 10)
        button.contentHorizontalAlignment = .center
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        button.isHidden = false
        return button
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
        view.addSubview(playerCountLabel)
        view.addSubview(playerCountDescriptionLabel)
        view.addSubview(keywordLabel)
        view.addSubview(menuNameLabel)
        view.addSubview(menuNameUnderline)
        view.addSubview(menuImageView)
//        view.addSubview(restaurantCheckButton)
        view.addSubview(nextMenuCheckButton)
        view.addSubview(shareButton)
        view.addSubview(gameRestartButton)

        let screenHeight = UIScreen.main.bounds.height
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            pinNumberLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            pinNumberLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            playerCountLabel.topAnchor.constraint(equalTo: pinNumberLabel.bottomAnchor, constant: screenHeight * 0.02),
            playerCountLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),

            playerCountDescriptionLabel.bottomAnchor.constraint(equalTo: playerCountLabel.bottomAnchor),
            playerCountDescriptionLabel.leadingAnchor.constraint(equalTo: playerCountLabel.trailingAnchor, constant: 2),
            
            keywordLabel.topAnchor.constraint(equalTo: playerCountLabel.bottomAnchor, constant: 5),
            keywordLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            menuNameLabel.topAnchor.constraint(equalTo: keywordLabel.bottomAnchor, constant: 5),
            menuNameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            
            menuNameUnderline.topAnchor.constraint(equalTo: menuNameLabel.bottomAnchor, constant: 2),
            menuNameUnderline.leadingAnchor.constraint(equalTo: menuNameLabel.leadingAnchor, constant: -2),
            menuNameUnderline.widthAnchor.constraint(equalTo: menuNameLabel.widthAnchor, constant: 4),
            menuNameUnderline.heightAnchor.constraint(equalToConstant: 3),

            menuImageView.topAnchor.constraint(equalTo: menuNameLabel.bottomAnchor, constant: screenHeight * 0.04),
            menuImageView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            menuImageView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            menuImageView.heightAnchor.constraint(greaterThanOrEqualTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.35),
            
//            restaurantCheckButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            restaurantCheckButton.bottomAnchor.constraint(equalTo: menuImageView.bottomAnchor, constant: -15),
//            restaurantCheckButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.5),
//            restaurantCheckButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.06),
            
            nextMenuCheckButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            nextMenuCheckButton.topAnchor.constraint(equalTo: menuImageView.bottomAnchor, constant: 15),
            nextMenuCheckButton.bottomAnchor.constraint(equalTo: shareButton.topAnchor, constant: -10),
            nextMenuCheckButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.6),
            nextMenuCheckButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.06),

            shareButton.bottomAnchor.constraint(equalTo: gameRestartButton.topAnchor, constant: -10),
            shareButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            shareButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.5),
            shareButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.05),

            gameRestartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            gameRestartButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            gameRestartButton.widthAnchor.constraint(equalToConstant: view.bounds.width * 0.5),
            gameRestartButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.05),
        ])
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

    private func configureContents(with inputObservable: Observable<(Menu, Int, String?)>) {
        inputObservable
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
                self.menuImageView.image = loadedImage
            }
        }
    }
    
    private func configureNextMenuContents(with inputObservable: Observable<(Menu?, Int)>) {
        inputObservable
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

    private func configureShareButtonDidTap(with shareButtonDidTap: Observable<Void>) {
        shareButtonDidTap
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { _ in
                guard
                    let menuName = self.menuNameLabel.text,
                    let keywords = self.keywordLabel.text
                else { return }
                
                let title = "[우리뭐먹지] 팀원과 오늘의 메뉴를 공유해보세요"
                let content = """
                [우리뭐먹지] 오늘의 메뉴는 #\(menuName) 입니다.
                팀원들이 이런 것을 원했어요. \(keywords)
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

// 오늘의 메뉴를 맛볼 수 있는 주변 식당도 알려드려요. // TODO: 지도 SDK 추가 후 공유 content에 추가
