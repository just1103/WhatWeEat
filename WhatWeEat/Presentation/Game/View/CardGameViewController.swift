import UIKit
import RxSwift
import RxCocoa

final class CardGameViewController: UIViewController {
    // MARK: - Nested Types
    private enum AnswerKind {
        case like
        case hate
        case skip
        
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
    private let previousQuestionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("이전 질문", for: .normal)
        button.setTitleColor(Design.previousQuestionButtonTitleColor, for: .normal)
        button.setImage(UIImage(systemName: "arrow.uturn.backward.circle"), for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.contentHorizontalAlignment = .leading
        button.isHidden = true
        return button
    }()
    private let pinNumberLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .body)
        label.textColor = ColorPalette.mainOrange
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 50
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: 0,
            leading: 20,
            bottom: 0,
            trailing: 20
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let likeButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Content.likeButtonTitle, for: .normal)
        button.setTitleColor(Design.skipButtonTitleColor, for: .normal)
        button.titleLabel?.font = Design.skipButtonTitleFont
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    private let hateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Content.hateButtonTitle, for: .normal)
        button.setTitleColor(Design.skipButtonTitleColor, for: .normal)
        button.titleLabel?.font = Design.skipButtonTitleFont
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    private let skipAndNextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("다음 (상관 없음)", for: .normal)
        button.setTitleColor(Design.skipButtonTitleColor, for: .normal)
        button.titleLabel?.font = Design.skipButtonTitleFont
        button.backgroundColor = Design.skipButtonBackgroundColor
        button.titleEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 30, right: 0)
        return button
    }()
    
    private var viewModel: CardGameViewModel!
    private let invokedViewDidLoad = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    private let card1 = YesOrNoCardView(image: UIImage(named: "spicy"), title: "스트레스 받으셨나요?") // TODO: 카드 내용 반영하여 네이밍 변경
    private let card2 = YesOrNoCardView(image: UIImage(named: "cheers"), title: "222")
    private let card3 = YesOrNoCardView(image: UIImage(named: "spicy"), title: "스트레스 받으셨나요?")
    private let card4 = YesOrNoCardView(image: UIImage(named: "cheers"), title: "222")
    private let card5 = YesOrNoCardView(image: UIImage(named: "spicy"), title: "스트레스 받으셨나요?")
    private let card6 = YesOrNoCardView(image: UIImage(named: "cheers"), title: "222")
    private let card7 = YesOrNoCardView(image: UIImage(named: "spicy"), title: "스트레스 받으셨나요?")
    private let card8 = MultipleChoiceCardView(title: "어떤 게 끌리세요?", subtitle: "(중복 선택 가능)")
    private let card9 = MultipleChoiceCardView(title: "어떤 게 끌리세요?", subtitle: "(중복 선택 가능)")
    private lazy var cards: [CardViewProtocol] = [card1, card2, card3, card4, card5, card6, card7, card8, card9]
    
    typealias CardIndicies = (Int, Int, Int)
    
    // MARK: - Initializers
    convenience init(viewModel: CardGameViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        hideNavigationBar()
        configureUI()
        bind()
        invokedViewDidLoad.onNext(())
    }
    
    // MARK: - Methods
    private func hideNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func configureUI() {
        view.addSubview(previousQuestionButton)
        view.addSubview(pinNumberLabel)
        view.addSubview(buttonStackView)
        view.addSubview(skipAndNextButton)
                
        buttonStackView.addArrangedSubview(likeButton)
        buttonStackView.addArrangedSubview(hateButton)
        
        NSLayoutConstraint.activate([
            previousQuestionButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            previousQuestionButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            previousQuestionButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            pinNumberLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            pinNumberLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),

            buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            buttonStackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            buttonStackView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.1),
            buttonStackView.bottomAnchor.constraint(equalTo: skipAndNextButton.topAnchor, constant: -30),
            
            skipAndNextButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            skipAndNextButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            skipAndNextButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.09),
            skipAndNextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func cardFrame(for index: Int) -> CGRect {
        switch index {
        case 0:
            let originX = UIScreen.main.bounds.width * 0.1
            let originY = UIScreen.main.bounds.height * 0.15
            
            let width = UIScreen.main.bounds.width * 0.8
            let height = UIScreen.main.bounds.height * 0.6
            
            return CGRect(origin: CGPoint(x: originX, y: originY),
                          size: CGSize(width: width, height: height))
        case 1:
            let originX = UIScreen.main.bounds.width * 0.11
            let originY = UIScreen.main.bounds.height * 0.14
            
            let width = UIScreen.main.bounds.width * (0.8 - 0.02)
            let height = UIScreen.main.bounds.height * 0.6
            
            return CGRect(origin: CGPoint(x: originX, y: originY),
                          size: CGSize(width: width, height: height))
        case 2:
            let originX = UIScreen.main.bounds.width * 0.12
            let originY = UIScreen.main.bounds.height * 0.13
            
            let width = UIScreen.main.bounds.width * (0.8 - 0.04)
            let height = UIScreen.main.bounds.height * 0.6
            
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
            likeButtonDidTap: likeButton.rx.tap.asObservable(),
            hateButtonDidTap: hateButton.rx.tap.asObservable(),
            skipButtonDidTap: skipAndNextButton.rx.tap.asObservable(),
            previousQuestionButtonDidTap: previousQuestionButton.rx.tap.asObservable(),
            menuNationsCellDidSelect: card8.choiceCollectionView.rx.itemSelected.asObservable(),
            mainIngredientsCellDidSelect: card9.choiceCollectionView.rx.itemSelected.asObservable()
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
                self.pinNumberLabel.text = "PIN Number : \(pinNumber)"
                self.pinNumberLabel.isHidden = false
            })
            .disposed(by: disposeBag)
    }
    
    private func configureMenuNations(with outputObservable: Observable<[MenuNation]>) {
        outputObservable
            .bind(to: card8.choiceCollectionView.rx.items(
                cellIdentifier: String(describing: GameSelectionCell.self),
                cellType: GameSelectionCell.self
            )) { [weak self] _, item, cell in
                self?.card8.changeCollectionViewLayout(for: .menuNation)
                cell.apply(isChecked: item.isChecked, descriptionText: item.descriptionText)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureMainIngredients(with outputObservable: Observable<[MainIngredient]>) {
        outputObservable
            .bind(to: card9.choiceCollectionView.rx.items(
                cellIdentifier: String(describing: GameSelectionCell.self),
                cellType: GameSelectionCell.self
            )) { [weak self] _, item, cell in
                self?.card9.changeCollectionViewLayout(for: .mainIngredient)
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
            submittedCard.alpha = 0

            firstCard.frame = self.cardFrame(for: 0)
            secondCard?.frame = self.cardFrame(for: 1)
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
        }
    }
    
    private func configureMenuNationsSelectedCellAndSkipButton(with indexPath: Observable<IndexPath>) {
        indexPath
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { (self, indexPath) in
                guard
                    let selectedCell = self.card8.choiceCollectionView.cellForItem(at: indexPath) as? GameSelectionCell
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
                    let selectedCell = self.card9.choiceCollectionView.cellForItem(at: indexPath) as? GameSelectionCell
                else { return }
                selectedCell.toggleSelectedCellUI()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - NameSpaces
extension CardGameViewController {
    private enum Design {
        static let previousQuestionButtonTitleColor: UIColor = .label
        static let skipButtonBackgroundColor: UIColor = ColorPalette.mainYellow
        static let skipButtonTitleColor: UIColor = .label
        static let skipButtonTitleFont: UIFont = .preferredFont(forTextStyle: .headline)
    }
    
    private enum Content {
        static let skipButtonTitle: String = "Skip"
        static let likeButtonTitle: String = "좋아요"
        static let hateButtonTitle: String = "싫어요"
    }
}
