import RxCocoa
import RxSwift
import UIKit

// 네비게이션바 레이블의 높이 = 설정 아이콘 높이 맞추기
// 홈메뉴의 네비게이션바 색상만 블랙으로 or 나머지는 화이트로 / 세 탭바 모두 그레이로 통일

final class CardGameViewController: UIViewController {
    // MARK: - Nested Types
    private enum AnswerKind {
        case like, hate, skip
        
        var nextAnimationCoordinate: (angle: CGFloat, x: CGFloat, y: CGFloat) {
            switch self {
            case .like:
                return (-(.pi / 4), -(UIScreen.main.bounds.width), -(UIScreen.main.bounds.height / 5))
            case .hate:
                return (.pi / 4, UIScreen.main.bounds.width, -(UIScreen.main.bounds.height / 5))
            case .skip:
                return (.zero, .zero, .zero)
            }
        }
    }
    
    // MARK: - Properties
    private let progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.translatesAutoresizingMaskIntoConstraints = false
        progressView.progressViewStyle = .default
        progressView.trackTintColor = Design.progressViewTrackTintColor
        progressView.progressTintColor = Design.progressViewProgressTintColor
//        progressView.setTitle(Text.previousQuestionButtonTitle, for: .normal)
//        progressView.setTitleColor(Design.previousQuestionButtonTitleColor, for: .normal)
//        progressView.setImage(Content.previousQuestionButtonImage, for: .normal)
//        progressView.tintColor = Design.previousQuestionButtonTintColor
//        progressView.titleLabel?.font = Design.previousQuestionButtonTitleFont
//        progressView.titleEdgeInsets = Design.previousQuestionButtonTitleInsets
//        progressView.contentHorizontalAlignment = .leading
//        progressView.isHidden = true
        return progressView
    }()
    private let previousQuestionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Text.previousQuestionButtonTitle, for: .normal)
        button.setTitleColor(Design.previousQuestionButtonTitleColor, for: .normal)
        button.setImage(Content.previousQuestionButtonImage, for: .normal)
        button.tintColor = Design.previousQuestionButtonTintColor
        button.titleLabel?.font = Design.previousQuestionButtonTitleFont
        button.titleEdgeInsets = Design.previousQuestionButtonTitleInsets
        button.contentHorizontalAlignment = .leading
        button.isHidden = true
        return button
    }()
    private let pinNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Design.pinNumberLabelFont
        label.textColor = Design.pinNumberLabelTextColor
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = Design.buttonStackViewSpacing
        stackView.directionalLayoutMargins = Design.buttonStackViewMargins
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let yesButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Text.yesButtonTitle, for: .normal)
        button.titleLabel?.font = Design.skipButtonTitleFont
        button.backgroundColor = Design.yesButtonBackgroundColor
        button.setTitleColor(Design.yesButtonTitleColor, for: .normal)
        button.clipsToBounds = true
        return button
    }()
    private let noButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Text.noButtonTitle, for: .normal)
        button.titleLabel?.font = Design.skipButtonTitleFont
        button.backgroundColor = .white
        button.setTitleColor(Design.noButtonTitleColor, for: .normal)
        button.layer.borderColor = Design.noButtonBorderColor
        button.layer.borderWidth = Design.noButtonBorderWidth
        button.clipsToBounds = true
        return button
    }()
    private let skipAndNextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Text.skipAndNextButtonTitle, for: .normal)
        button.setTitleColor(Design.skipButtonTitleColor, for: .normal)
        button.titleLabel?.font = Design.skipButtonTitleFont
        button.backgroundColor = Design.skipButtonBackgroundColor
        button.titleEdgeInsets = Design.skipAndNextButtonTitleInsets
        return button
    }()
    
    private var viewModel: CardGameViewModel!
    private let invokedViewDidLoad = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    private let hangoverCard = YesOrNoCardView(image: Content.hangoverCardImage, title: Text.hangoverCardTitle)
    private let greasyCard = YesOrNoCardView(image: Content.greasyCardImage, title: Text.greasyCardTitle)
    private let healthyCard = YesOrNoCardView(image: Content.healthyCardImage, title: Text.healthCardTitle)
    private let alcoholCard = YesOrNoCardView(image: Content.alcoholCardImage, title: Text.alcoholCardTitle)
    private let instantCard = YesOrNoCardView(image: Content.instantCardImage, title: Text.instantCardTitle)
    private let spicyCard = YesOrNoCardView(image: Content.spicyCardImage, title: Text.spicyCardTitle)
    private let richCard = YesOrNoCardView(image: Content.richCardImage, title: Text.richCardTitle)
    private let mainIngredientCard = MultipleChoiceCardView(
        title: Text.mainIngredientCardTitle,
        subtitle: Text.mainIngredientCardSubtitle
    )
    private let nationCard = MultipleChoiceCardView(
        title: Text.nationCardTitle,
        subtitle: Text.nationCardSubtitle
    )
    private lazy var cards: [CardViewProtocol] = [
        hangoverCard, greasyCard, healthyCard, alcoholCard, instantCard, spicyCard, richCard, mainIngredientCard, nationCard
    ]
    private var progressForEachCard: Float {
        return Float(1) / Float(cards.count)
    }
    
    typealias CardIndicies = (Int, Int, Int)
    
    // MARK: - Initializers
    convenience init(viewModel: CardGameViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
        invokedViewDidLoad.onNext(())
    }
    
    // MARK: - Methods
    private func configureUI() {
        view.addSubview(progressView)
        view.addSubview(previousQuestionButton)
        view.addSubview(pinNumberLabel)
        view.addSubview(buttonStackView)
        view.addSubview(skipAndNextButton)
        
        buttonStackView.addArrangedSubview(yesButton)
        buttonStackView.addArrangedSubview(noButton)
        
        progressView.progress = progressForEachCard
        
        yesButton.layer.cornerRadius = Design.yesButtonCornerRadius
        noButton.layer.cornerRadius = Design.noButtonCornerRadius
        
        NSLayoutConstraint.activate([
            progressView.topAnchor.constraint(
                equalTo: view.topAnchor,
                constant: Constraint.progressViewTopAnchorConstant
            ),
            progressView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            progressView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            progressView.heightAnchor.constraint(equalToConstant: Constraint.progressViewHeightAnchorConstant),
            
            previousQuestionButton.topAnchor.constraint(
                equalTo: progressView.bottomAnchor,
                constant: Constraint.previousQuestionButtonTopAnchorConstant
            ),
            previousQuestionButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constraint.previousQuestionButtonLeadingAnchorConstant
            ),
            previousQuestionButton.widthAnchor.constraint(
                equalTo: view.widthAnchor,
                multiplier: Constraint.previousQuestionButtonWidthAnchorMultiplier
            ),
            
            pinNumberLabel.topAnchor.constraint(
                equalTo: progressView.bottomAnchor,
                constant: Constraint.pinNumberLabelTopAnchorConstant
            ),
            pinNumberLabel.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: Constraint.pinNumberLabelTrailingAnchorConstant
            ),

            buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            buttonStackView.widthAnchor.constraint(equalToConstant: Constraint.buttonStackViewWidthAnchorConstant),
            buttonStackView.heightAnchor.constraint(equalToConstant: Constraint.buttonStackViewHeightAnchorConstant),
            buttonStackView.bottomAnchor.constraint(
                equalTo: skipAndNextButton.topAnchor,
                constant: Constraint.buttonStackViewBottomAnchorConstant
            ),
            
            skipAndNextButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            skipAndNextButton.widthAnchor.constraint(equalToConstant: Constraint.skipAndNextButtonWidthAnchorConstant),
            skipAndNextButton.heightAnchor.constraint(equalToConstant: Constraint.skipAndNextButtonHeightAnchorConstant),
            skipAndNextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func cardFrame(for index: Int) -> CGRect {
        switch index {
        case 0:
            let originX = Design.firstCardOriginX
            let originY = Design.firstCardOriginY
            
            let width = Design.firstCardWidth
            let height = Design.cardHeight
            
            return CGRect(origin: CGPoint(x: originX, y: originY),
                          size: CGSize(width: width, height: height))
        case 1:
            let originX = Design.secondCardOriginX
            let originY = Design.secondCardOriginY
            
            let width = Design.secondCardWidth
            let height = Design.cardHeight
            
            return CGRect(origin: CGPoint(x: originX, y: originY),
                          size: CGSize(width: width, height: height))
        case 2:
            let originX = Design.thirdCardOriginX
            let originY = Design.thirdCardOriginY
            
            let width = Design.thirdCardWidth
            let height = Design.cardHeight
            
            return CGRect(origin: CGPoint(x: originX, y: originY),
                          size: CGSize(width: width, height: height))
        default:
            return .zero
        }
    }
}

// MARK: - Rx Binding Methods
extension CardGameViewController {
    private func bind() {
        let input = CardGameViewModel.Input(
            invokedViewDidLoad: invokedViewDidLoad.asObservable(),
            yesButtonDidTap: yesButton.rx.tap.asObservable(),
            noButtonDidTap: noButton.rx.tap.asObservable(),
            skipButtonDidTap: skipAndNextButton.rx.tap.asObservable(),
            previousQuestionButtonDidTap: previousQuestionButton.rx.tap.asObservable(),
            menuNationsCellDidSelect: mainIngredientCard.choiceCollectionView.rx.itemSelected.asObservable(),
            mainIngredientsCellDidSelect: nationCard.choiceCollectionView.rx.itemSelected.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        configureInitialCardIndiciesAndPinNumber(with: output.initialCardIndiciesAndPinNumber)
        configureMenuNations(with: output.menuNations)
        configureMainIngredients(with: output.mainIngredients)
        configureNextCardIndiciesWhenLike(with: output.nextCardIndiciesWhenLike)
        configureNextCardIndiciesWhenHate(with: output.nextCardIndiciesWhenHate)
        configureNextCardIndiciesWhenSkip(with: output.nextCardIndiciesWhenSkip)
        configurePreviousCardIndiciesAndResult(with: output.previousCardIndiciesAndResult)
        configureMenuNationsSelectedCellAndSkipButton(with: output.menuNationsSelectedindexPath)
        configureMainIngredientsSelectedCellAndSkipButton(with: output.mainIngredientsSelectedindexPath)
    }
    
    private func configureInitialCardIndiciesAndPinNumber(with outputObservable: Observable<(CardIndicies, String?)>) {
        outputObservable
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { (self, initialCardIndiciesAndPinNumber) in
                let ((first, second, third), pinNumber) = initialCardIndiciesAndPinNumber
                guard
                    let firstCard = self.cards[safe: first],
                    let secondCard = self.cards[safe: second],
                    let thirdCard = self.cards[safe: third]
                else { return }
                
                self.view.addSubview(thirdCard)
                self.view.addSubview(secondCard)
                self.view.addSubview(firstCard)
                
                thirdCard.frame = self.cardFrame(for: 2)
                secondCard.frame = self.cardFrame(for: 1)
                firstCard.frame = self.cardFrame(for: 0)
                
                guard let pinNumber = pinNumber else {
                    self.pinNumberLabel.isHidden = true
                    return
                }
                self.pinNumberLabel.text = "PIN NUMBER : \(pinNumber)"
                self.pinNumberLabel.isHidden = false
            })
            .disposed(by: disposeBag)
    }
    
    private func configureMenuNations(with outputObservable: Observable<[MenuNation]>) {
        outputObservable
            .bind(to: mainIngredientCard.choiceCollectionView.rx.items(
                cellIdentifier: String(describing: GameSelectionCell.self),
                cellType: GameSelectionCell.self
            )) { [weak self] _, item, cell in
                self?.mainIngredientCard.changeCollectionViewUI(for: .menuNation)
                cell.apply(isChecked: item.isChecked, descriptionText: item.descriptionText)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureMainIngredients(with outputObservable: Observable<[MainIngredient]>) {
        outputObservable
            .bind(to: nationCard.choiceCollectionView.rx.items(
                cellIdentifier: String(describing: GameSelectionCell.self),
                cellType: GameSelectionCell.self
            )) { [weak self] _, item, cell in
                self?.nationCard.changeCollectionViewUI(for: .mainIngredient)
                cell.apply(isChecked: item.isChecked, descriptionText: item.descriptionText)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureNextCardIndiciesWhenLike(with outputObservable: Observable<CardIndicies>) {
        outputObservable
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { (self, cardIndicies) in
                self.showNextCard(with: cardIndicies, answerKind: .like)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureNextCardIndiciesWhenHate(with outputObservable: Observable<CardIndicies>) {
        outputObservable
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { (self, cardIndicies) in
                self.showNextCard(with: cardIndicies, answerKind: .hate)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureNextCardIndiciesWhenSkip(with outputObservable: Observable<CardIndicies>) {
        outputObservable
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { (self, cardIndicies) in
                self.showNextCard(with: cardIndicies, answerKind: .skip)
            })
            .disposed(by: disposeBag)
    }
    
    private func showNextCard(with cardIndicies: CardIndicies, answerKind: AnswerKind) {
        previousQuestionButton.isHidden = false
        
        let (first, second, third) = cardIndicies
        let submittedCardIndex = first - 1
        
        let firstIndexOfMultipleChoiceCard = 7
        if first >= firstIndexOfMultipleChoiceCard {
            buttonStackView.isHidden = true
        }
        
        guard
            let firstCard = cards[safe: first],
            let submittedCard = cards[safe: submittedCardIndex]
        else { return }
        
        nextCardAnimation(
            firstCard: firstCard,
            secondCard: cards[safe: second],
            thirdCard: cards[safe: third],
            submittedCard: submittedCard,
            animationCoordinate: answerKind.nextAnimationCoordinate
        )
    }
    
    private func nextCardAnimation(
        firstCard: CardViewProtocol,
        secondCard: CardViewProtocol?,
        thirdCard: CardViewProtocol?,
        submittedCard: CardViewProtocol,
        animationCoordinate: (angle: CGFloat, x: CGFloat, y: CGFloat)
    ) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn) { [weak self] in
            guard let self = self else { return }
            let rotate = CGAffineTransform(rotationAngle: animationCoordinate.angle)
            let move = CGAffineTransform(
                translationX: animationCoordinate.x,
                y: animationCoordinate.y
            )
            let combine = rotate.concatenating(move)
            submittedCard.transform = combine
            submittedCard.alpha = .zero

            firstCard.frame = self.cardFrame(for: 0)
            secondCard?.frame = self.cardFrame(for: 1)
            
            self.progressView.progress += self.progressForEachCard
        } completion: { [weak self] _ in
            guard let self = self else { return }
            submittedCard.removeFromSuperview()
            
            guard let thirdCard = thirdCard else { return }
            self.view.insertSubview(thirdCard, at: 0)
            thirdCard.frame = self.cardFrame(for: 2)
        }
    }
    
    private func configurePreviousCardIndiciesAndResult(with outputObservable: Observable<(CardIndicies, Bool?)>) {
        outputObservable
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { (self, cardIndiciesAndResult) in
                let (previousCardIndicies, latestAnswer) = cardIndiciesAndResult
                
                var answerKind: AnswerKind?
                switch latestAnswer {
                case .some(true):
                    answerKind = .like
                case .some(false):
                    answerKind = .hate
                case .none:
                    answerKind = .skip
                }
                guard let answerKind = answerKind else { return }

                self.showPreviousCard(with: previousCardIndicies, answerKind: answerKind)
            })
            .disposed(by: disposeBag)
    }

    private func showPreviousCard(with cardIndicies: CardIndicies, answerKind: AnswerKind) {
        let (first, second, third) = cardIndicies
        
        let previousThirdCardIndex = third + 1
        guard let firstCard = self.cards[safe: first] else { return }
        
        let firstIndexOfMultipleChoiceCard = 7
        if first == 0 {
            previousQuestionButton.isHidden = true
        } else if first <= firstIndexOfMultipleChoiceCard - 1 {
            buttonStackView.isHidden = false
        }
        
        self.view.addSubview(firstCard)
        previousCardAnimation(
            firstCard: firstCard,
            secondCard: self.cards[safe: second],
            thirdCard: self.cards[safe: third],
            previousThirdCard: self.cards[safe: previousThirdCardIndex]
        )
    }
    
    private func previousCardAnimation(
        firstCard: CardViewProtocol,
        secondCard: CardViewProtocol?,
        thirdCard: CardViewProtocol?,
        previousThirdCard: CardViewProtocol?
    ) {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut) { [weak self] in
            guard let self = self else { return }
            let rotate = CGAffineTransform(rotationAngle: .zero)
            firstCard.transform = rotate
            firstCard.alpha = 1

            firstCard.frame = self.cardFrame(for: 0)
            secondCard?.frame = self.cardFrame(for: 1)
            thirdCard?.frame = self.cardFrame(for: 2)
            
            previousThirdCard?.removeFromSuperview()
            
            self.progressView.progress -= self.progressForEachCard
        }
    }
    
    private func configureMenuNationsSelectedCellAndSkipButton(with indexPath: Observable<IndexPath>) {
        indexPath
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { (self, indexPath) in
                guard
                    let selectedCell = self.mainIngredientCard.choiceCollectionView.cellForItem(at: indexPath) as? GameSelectionCell
                else { return }
                selectedCell.toggleSelectedCellUI()
            })
            .disposed(by: disposeBag)
    }
    
    private func configureMainIngredientsSelectedCellAndSkipButton(with indexPath: Observable<IndexPath>) {
        indexPath
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { (self, indexPath) in
                guard
                    let selectedCell = self.nationCard.choiceCollectionView.cellForItem(at: indexPath) as? GameSelectionCell
                else { return }
                selectedCell.toggleSelectedCellUI()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - NameSpaces
extension CardGameViewController {
    private enum Design {
        static let progressViewTrackTintColor: UIColor = .subYellow
        static let progressViewProgressTintColor: UIColor = .mainOrange
        static let previousQuestionButtonTitleColor: UIColor = .label
        static let skipButtonBackgroundColor: UIColor = .mainYellow
        static let skipButtonTitleColor: UIColor = .label
        static let skipButtonTitleFont: UIFont = .pretendard(family: .regular, size: 20)
        static let previousQuestionButtonTintColor: UIColor = .black
        static let previousQuestionButtonTitleFont: UIFont = .pretendard(family: .regular, size: 15)
        static let previousQuestionButtonTitleInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        static let pinNumberLabelTextColor: UIColor = .mainOrange
        static let pinNumberLabelFont: UIFont = .pretendard(family: .regular, size: 15)
        static let buttonStackViewSpacing: CGFloat = 50
        static let buttonStackViewMargins = NSDirectionalEdgeInsets(
            top: 0,
            leading: UIScreen.main.bounds.width * 0.1,
            bottom: 0,
            trailing: UIScreen.main.bounds.width * 0.1
        )
        static let yesButtonBackgroundColor: UIColor = .mainOrange
        static let yesButtonTitleColor: UIColor = .white
        static let yesButtonCornerRadius: CGFloat = UIScreen.main.bounds.height * 0.1 * 0.5
        static let noButtonCornerRadius: CGFloat = UIScreen.main.bounds.height * 0.1 * 0.5
        static let noButtonTitleColor: UIColor = .mainOrange
        static let noButtonBorderColor: CGColor = UIColor.mainOrange.cgColor
        static let noButtonBorderWidth: CGFloat = 2
        static let skipAndNextButtonTitleInsets = UIEdgeInsets(top: 15, left: 0, bottom: 30, right: 0)
        static let firstCardOriginX = UIScreen.main.bounds.width * 0.1
        static let firstCardOriginY = UIScreen.main.bounds.height * 0.15
        static let firstCardWidth = UIScreen.main.bounds.width * 0.8
        static let cardHeight = UIScreen.main.bounds.height * 0.6
        static let secondCardOriginX = UIScreen.main.bounds.width * 0.11
        static let secondCardOriginY = UIScreen.main.bounds.height * 0.14
        static let secondCardWidth = UIScreen.main.bounds.width * (0.8 - 0.02)
        static let thirdCardOriginX = UIScreen.main.bounds.width * 0.12
        static let thirdCardOriginY = UIScreen.main.bounds.height * 0.13
        static let thirdCardWidth = UIScreen.main.bounds.width * (0.8 - 0.04)
    }
    
    private enum Constraint {
        static let progressViewTopAnchorConstant: CGFloat = 45
        static let progressViewHeightAnchorConstant: CGFloat = 5
        static let previousQuestionButtonTopAnchorConstant: CGFloat = 10
        static let previousQuestionButtonLeadingAnchorConstant: CGFloat = 15
        static let previousQuestionButtonWidthAnchorMultiplier = 0.5
        static let pinNumberLabelTopAnchorConstant: CGFloat = 10
        static let pinNumberLabelTrailingAnchorConstant: CGFloat = -15
        static let buttonStackViewWidthAnchorConstant: CGFloat = UIScreen.main.bounds.width
        static let buttonStackViewHeightAnchorConstant: CGFloat = UIScreen.main.bounds.height * 0.1
        static let buttonStackViewBottomAnchorConstant: CGFloat = -30
        static let skipAndNextButtonWidthAnchorConstant: CGFloat = UIScreen.main.bounds.width
        static let skipAndNextButtonHeightAnchorConstant: CGFloat = UIScreen.main.bounds.height * 0.09
    }
    
    private enum Content {
        static let previousQuestionButtonImage = UIImage(systemName: "arrow.uturn.backward.circle")
        static let hangoverCardImage = UIImage(named: "hangover")
        static let greasyCardImage = UIImage(named: "greasy")
        static let healthyCardImage = UIImage(named: "healthy")
        static let alcoholCardImage = UIImage(named: "alcohol")
        static let instantCardImage = UIImage(named: "instant")
        static let spicyCardImage = UIImage(named: "spicy")
        static let richCardImage = UIImage(named: "rich")
    }
    
    private enum Text {
        static let skipButtonTitle: String = "Skip"
        static let yesButtonTitle: String = "Yes"
        static let noButtonTitle: String = "No"
        static let previousQuestionButtonTitle = "이전 질문"
        static let skipAndNextButtonTitle = "다음 (상관 없음)"
        static let hangoverCardTitle = "해장이 필요하신가요?"
        static let greasyCardTitle = "장에 기름칠하고 싶으신가요?"
        static let healthCardTitle = "건강을 챙기시나요?"
        static let alcoholCardTitle = "한 잔 하시나요?"
        static let instantCardTitle = "바빠서 빨리 드셔야 하나요?"
        static let spicyCardTitle = "스트레스 받으셨나요?"
        static let richCardTitle = "오늘은 돈 걱정 없으신가요?"
        static let mainIngredientCardTitle = "어떤 게 끌리세요?"
        static let mainIngredientCardSubtitle = "(다중선택 가능)"
        static let nationCardTitle = "어떤 게 끌리세요?"
        static let nationCardSubtitle = "(다중선택 가능)"
    }
}
