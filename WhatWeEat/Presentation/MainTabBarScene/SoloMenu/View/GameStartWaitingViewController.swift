import Lottie
import RxCocoa
import UIKit

class GameStartWaitingViewController: UIViewController {
    // MARK: - Properties
    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Design.backgroundViewColor
        return view
    }()
    private let circleAnimationView: AnimationView = {
        let animationView = Content.circleAnimationView
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        return animationView
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Design.descriptionLabelFont
        label.text = Text.descriptionLabelText
        label.textColor = Design.descriptionLabelTextColor
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    private let personImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Content.personImage
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.init(100), for: .vertical)
        imageView.tintColor = Design.personImageViewTintColor
        return imageView
    }()
    private let readyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Design.readyLabelFont
        label.text = Text.readyLabelText
        label.textColor = Design.readyLabelTextColor
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    let gameStartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Text.gameStartButtonTitle, for: .normal)
        button.setTitleColor(Design.gameStartButtonTitleColor, for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = Design.gameStartButtonTitleFont
        button.layer.cornerRadius = Design.gameStartButtonCornerRadius
        button.clipsToBounds = true
        return button
    }()
    
    func configureUI() {
        view.backgroundColor = Design.backgroundColor
        view.addSubview(backgroundView)
        view.addSubview(circleAnimationView)
        view.addSubview(descriptionLabel)
        view.addSubview(personImageView)
        view.addSubview(readyLabel)
        view.addSubview(gameStartButton)
        
        gameStartButton.applyShadow(direction: .bottom)
        circleAnimationView.play()
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            circleAnimationView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            circleAnimationView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            circleAnimationView.widthAnchor.constraint(
                equalToConstant: Constraint.circleAnimationViewWidthAnchorConstant
            ),
            circleAnimationView.heightAnchor.constraint(equalTo: circleAnimationView.widthAnchor),
            
            personImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            personImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            personImageView.widthAnchor.constraint(
                equalToConstant: Constraint.personImageViewWidthAnchorConstant
            ),
            personImageView.heightAnchor.constraint(equalTo: personImageView.widthAnchor),
            
            descriptionLabel.bottomAnchor.constraint(
                equalTo: personImageView.topAnchor,
                constant: Constraint.descriptionLabelBottomAnchorConstant
            ),
            descriptionLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constraint.descriptionLabelLeadingAnchorConstant
            ),
            descriptionLabel.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: Constraint.descriptionLabelTrailingAnchorConstant
            ),
            
            readyLabel.bottomAnchor.constraint(
                equalTo: gameStartButton.topAnchor,
                constant: Constraint.readyLabelBottomAnchorConstant
            ),
            readyLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constraint.readyLabelLeadingAnchorConstant
            ),
            readyLabel.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: Constraint.readyLabelTrailingAnchorConstant
            ),
            
            gameStartButton.bottomAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.bottomAnchor,
                constant: Constraint.gameStartButtonBottomAnchorConstant
            ),
            gameStartButton.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constraint.gameStartButtonLeadingAnchorConstant
            ),
            gameStartButton.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: Constraint.gameStartButtonTrailingAnchorConstant
            ),
            gameStartButton.heightAnchor.constraint(
                equalToConstant: Constraint.gameStartButtonHeightAnchorConstant
            ),
        ])
    }
}

// MARK: - Namespaces
extension GameStartWaitingViewController {
    private enum Design {
        static let backgroundViewColor: UIColor = .mainOrange
        static let descriptionLabelFont: UIFont = .pretendard(family: .bold, size: 30)
        static let descriptionLabelTextColor: UIColor = .white
        static let personImageViewTintColor: UIColor = .white
        static let readyLabelFont: UIFont = .pretendard(family: .medium, size: 25)
        static let readyLabelTextColor: UIColor = .white
        static let gameStartButtonTitleColor: UIColor = .mainOrange
        static let gameStartButtonTitleFont: UIFont = .pretendard(family: .medium, size: 30)
        static let gameStartButtonBackgroundColor: UIColor = .white
        static let gameStartButtonCornerRadius: CGFloat =  UIScreen.main.bounds.height * 0.08 * 0.5
        static let backgroundColor: UIColor = .lightGray
    }
    
    private enum Constraint {
        static let circleAnimationViewWidthAnchorConstant: CGFloat = UIScreen.main.bounds.width * 1.5
        static let personImageViewWidthAnchorConstant: CGFloat = UIScreen.main.bounds.width * 0.4
        static let descriptionLabelBottomAnchorConstant: CGFloat = -40
        static let descriptionLabelLeadingAnchorConstant: CGFloat = 40
        static let descriptionLabelTrailingAnchorConstant: CGFloat = -40
        static let readyLabelBottomAnchorConstant: CGFloat = -30
        static let readyLabelLeadingAnchorConstant: CGFloat = 40
        static let readyLabelTrailingAnchorConstant: CGFloat = -40
        static let gameStartButtonBottomAnchorConstant: CGFloat = -50
        static let gameStartButtonLeadingAnchorConstant: CGFloat = 50
        static let gameStartButtonTrailingAnchorConstant: CGFloat = -50
        static let gameStartButtonHeightAnchorConstant: CGFloat = UIScreen.main.bounds.height * 0.08
    }
    
    private enum Content {
        static let circleAnimationView = AnimationView(name: "circle")
        static let personImage = UIImage(systemName: "person.fill")
    }
    
    private enum Text {
        static let descriptionLabelText = """
        장의 소리에
        귀 기울여주세요...
        """
        static let readyLabelText = "준비되셨다면"
        static let gameStartButtonTitle = "미니게임 시작"
    }
}
