import UIKit
import RxSwift
import RxCocoa

final class GameViewController: UIViewController {
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
        return button
    }()
    private let pinNumberLabel: UILabel = {
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
        button.setTitle(Content.skipButtonTitle, for: .normal)
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
        button.setTitle(Content.skipButtonTitle, for: .normal)
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
        
    var cards = [CardView]()  // TODO: ViewModel로 분리
    private let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let card1 = CardView(image: UIImage(named: "spicy"), title: "스트레스 받으셨나요?")
        let card2 = CardView(image: UIImage(named: "cheers"), title: "222")
        let card3 = CardView(image: UIImage(named: "spicy"), title: "스트레스 받으셨나요?")
        let card4 = CardView(image: UIImage(named: "cheers"), title: "222")
        cards = [card1, card2, card3, card4]
        
        hideNavigationBar()
        configureUI()
        bind()
    }
    
    private func hideNavigationBar() {
        navigationController?.navigationBar.isHidden = true
    }
    
    private func configureUI() {
        view.addSubview(cards[2])
        view.addSubview(cards[1])
        view.addSubview(cards[0])
        
        cards[2].frame = cardFrame(for: 2)
        cards[1].frame = cardFrame(for: 1)
        cards[0].frame = cardFrame(for: 0)
        
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
    
    private func bind() {
        likeButton.rx.tap.asObservable()
            .subscribe(onNext: { [weak self] in
                guard let self = self else { return }
                UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseIn) {
                    self.cards[0].removeFromSuperview()
                    
                    self.cards[1].frame = self.cardFrame(for: 0)
                    self.cards[2].frame = self.cardFrame(for: 1)
                } completion: { _ in
                    self.view.insertSubview(self.cards[3], at: 0)
                    self.cards[3].frame = self.cardFrame(for: 2)
                }
            })
            .disposed(by: disposeBag)
    }
    
//    private func setupDeck() {
//        if let dataSource = dataSource {
//            countOfCards = dataSource.kolodaNumberOfCards(self)
//
//            if countOfCards - currentCardIndex > 0 {
//                let countOfNeededCards = min(countOfVisibleCards, countOfCards - currentCardIndex)
//
//                for index in 0..<countOfNeededCards {
//                    let actualIndex = index + currentCardIndex
//                    let nextCardView = createCard(at: actualIndex)
//                    let isTop = index == 0
//                    nextCardView.isUserInteractionEnabled = isTop
//                    nextCardView.alpha = alphaValueOpaque
//                    if shouldTransparentizeNextCard && !isTop {
//                        nextCardView.alpha = alphaValueSemiTransparent
//                    }
//                    visibleCards.append(nextCardView)
//                    isTop ? addSubview(nextCardView) : insertSubview(nextCardView, belowSubview: visibleCards[index - 1])
//                }
//                self.delegate?.koloda(self, didShowCardAt: currentCardIndex)
//            }
//        }
//    }
}

// MARK: - NameSpaces
extension GameViewController {
    private enum Design {
        static let pageControlCurrentPageIndicatorTintColor: UIColor = ColorPalette.mainYellow
        static let pageControlPageIndicatorTintColor: UIColor = .systemGray
        static let skipAndConfirmButtonBackgroundColor: UIColor = ColorPalette.mainYellow
        static let skipAndConfirmButtonTitleColor: UIColor = .label
        static let skipAndConfirmButtonTitleFont: UIFont = .preferredFont(forTextStyle: .headline)
    }
    
    private enum Content {
        static let skipButtonTitle: String = "Skip"
    }
}
