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
        button.setTitleColor(Design.skipAndConfirmButtonTitleColor, for: .normal)
        button.setImage(UIImage(systemName: "arrow.uturn.backward.circle"), for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.contentHorizontalAlignment = .leading
        button.isHidden = true
        return button
    }()
    private let pinNumberLabel: UILabel = {  // TODO: 탭바버튼 종류에 따라 isHidden 처리
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .body)
        label.text = "PIN NUMBER : 1111"
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
        button.setTitleColor(Design.skipAndConfirmButtonTitleColor, for: .normal)
        button.titleLabel?.font = Design.skipAndConfirmButtonTitleFont
        button.backgroundColor = .systemRed
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    private let hateButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Content.hateButtonTitle, for: .normal)
        button.setTitleColor(Design.skipAndConfirmButtonTitleColor, for: .normal)
        button.titleLabel?.font = Design.skipAndConfirmButtonTitleFont
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 8
        button.clipsToBounds = true
        return button
    }()
    private let skipButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("상관 없음", for: .normal)
        button.setTitleColor(Design.skipAndConfirmButtonTitleColor, for: .normal)
        button.titleLabel?.font = Design.skipAndConfirmButtonTitleFont
        button.backgroundColor = Design.skipAndConfirmButtonBackgroundColor
        button.titleEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 30, right: 0)
        return button
    }()
    
    private var viewModel: CardGameViewModel!
    private let invokedViewDidLoad = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    private let card1 = CardView(image: UIImage(named: "spicy"), title: "스트레스 받으셨나요?")
    private let card2 = CardView(image: UIImage(named: "cheers"), title: "222")
    private let card3 = CardView(image: UIImage(named: "spicy"), title: "스트레스 받으셨나요?")
    private let card4 = CardView(image: UIImage(named: "cheers"), title: "222")
    private let card5 = CardView(image: UIImage(named: "spicy"), title: "스트레스 받으셨나요?")
    private let card6 = CardView(image: UIImage(named: "cheers"), title: "222")
    private let card7 = CardView(image: UIImage(named: "spicy"), title: "스트레스 받으셨나요?")
    private lazy var cards = [card1, card2, card3, card4, card5, card6, card7]
    
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
        view.addSubview(skipButton)
                
        buttonStackView.addArrangedSubview(likeButton)
        buttonStackView.addArrangedSubview(hateButton)
        
        NSLayoutConstraint.activate([
            previousQuestionButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            previousQuestionButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            previousQuestionButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            pinNumberLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            pinNumberLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),

            buttonStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            buttonStackView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            buttonStackView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.13),
            buttonStackView.bottomAnchor.constraint(equalTo: skipButton.topAnchor, constant: -30),
            
            skipButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            skipButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            skipButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.09),
            skipButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func cardFrame(for index: Int) -> CGRect {
        switch index {
        case 0:
            let originX = UIScreen.main.bounds.width * 0.1
            let originY = UIScreen.main.bounds.height * 0.2
            
            let width = UIScreen.main.bounds.width * 0.8
            let height = UIScreen.main.bounds.height * 0.5
            
            return CGRect(origin: CGPoint(x: originX, y: originY),
                          size: CGSize(width: width, height: height))
        case 1:
            let originX = UIScreen.main.bounds.width * 0.11
            let originY = UIScreen.main.bounds.height * 0.19
            
            let width = UIScreen.main.bounds.width * (0.8 - 0.02)
            let height = UIScreen.main.bounds.height * 0.5
            
            return CGRect(origin: CGPoint(x: originX, y: originY),
                          size: CGSize(width: width, height: height))
        case 2:
            let originX = UIScreen.main.bounds.width * 0.12
            let originY = UIScreen.main.bounds.height * 0.18
            
            let width = UIScreen.main.bounds.width * (0.8 - 0.04)
            let height = UIScreen.main.bounds.height * 0.5
            
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
            skipButtonDidTap: skipButton.rx.tap.asObservable(),
            previousQuestionButtonDidTap: previousQuestionButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        configureInitialCardIndicies(with: output.initialCardIndicies)
        configureNextCardIndiciesWhenLike(with: output.nextCardIndiciesWhenLike)
        configureNextCardIndiciesWhenHate(with: output.nextCardIndiciesWhenHate)
        configureNextCardIndiciesWhenSkip(with: output.nextCardIndiciesWhenSkip)
        configurePreviousCardIndiciesAndResultObservable(with: output.previousCardIndiciesAndResult)
    }
    
    private func configureInitialCardIndicies(with outputObservable: Observable<CardIndicies>) {
        outputObservable
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { (self, cardIndicies) in
                let (first, second, third) = cardIndicies
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
            })
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
        firstCard: CardView,
        secondCard: CardView?,
        thirdCard: CardView?,
        submittedCard: CardView,
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
    
    private func configurePreviousCardIndiciesAndResultObservable(with outputObservable: Observable<(CardIndicies, Bool?)>) {
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
        
        if first == 0 {
            previousQuestionButton.isHidden = true
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
        firstCard: CardView,
        secondCard: CardView?,
        thirdCard: CardView?,
        previousThirdCard: CardView?
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
}

// MARK: - NameSpaces
extension CardGameViewController {
    private enum Design {
        static let pageControlCurrentPageIndicatorTintColor: UIColor = ColorPalette.mainYellow
        static let pageControlPageIndicatorTintColor: UIColor = .systemGray
        static let skipAndConfirmButtonBackgroundColor: UIColor = ColorPalette.mainYellow
        static let skipAndConfirmButtonTitleColor: UIColor = .label
        static let skipAndConfirmButtonTitleFont: UIFont = .preferredFont(forTextStyle: .headline)
    }
    
    private enum Content {
        static let skipButtonTitle: String = "Skip"
        static let likeButtonTitle: String = "좋아요"
        static let hateButtonTitle: String = "싫어요"
    }
}
