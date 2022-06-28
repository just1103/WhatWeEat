import Lottie
import UIKit
import RxCocoa

class GameStartWaitingViewController: UIViewController {
    // MARK: - Properties
    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .mainOrange
        return view
    }()
    private let circleAnimationView: AnimationView = {
        let animationView = AnimationView(name: "circle")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        return animationView
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .pretendard(family: .bold, size: 30)
        label.text = """
        장의 소리에
        귀 기울여주세요...
        """
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    private let personImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.setContentHuggingPriority(.init(100), for: .vertical)
        imageView.tintColor = .white
        return imageView
    }()
    private let readyLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = .pretendard(family: .medium, size: 25)
        label.text = "준비되셨다면"
        label.textColor = .white
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.setContentHuggingPriority(.required, for: .vertical)
        return label
    }()
    let gameStartButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("미니게임 시작", for: .normal)
        button.setTitleColor(.mainOrange, for: .normal)
        button.backgroundColor = .white
        button.titleLabel?.font = .pretendard(family: .medium, size: 30)
        button.layer.cornerRadius = UIScreen.main.bounds.height * 0.08 * 0.5
        button.clipsToBounds = true
        return button
    }()
    
    func configureUI() {
        view.backgroundColor = .systemGray6
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
            circleAnimationView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 1.5),
            circleAnimationView.heightAnchor.constraint(equalTo: circleAnimationView.widthAnchor),
            
            personImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            personImageView.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            personImageView.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width * 0.4),
            personImageView.heightAnchor.constraint(equalTo: personImageView.widthAnchor),
            
            descriptionLabel.bottomAnchor.constraint(equalTo: personImageView.topAnchor, constant: -40),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            
            readyLabel.bottomAnchor.constraint(equalTo: gameStartButton.topAnchor, constant: -30),
            readyLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            readyLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            
            gameStartButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            gameStartButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 40),
            gameStartButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -40),
            gameStartButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.08),
        ])
    }
}
