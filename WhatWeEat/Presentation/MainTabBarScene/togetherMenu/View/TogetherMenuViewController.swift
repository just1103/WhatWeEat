import UIKit
import SwiftUI

final class TogetherMenuViewController: UIViewController, TabBarContentProtocol {
    // MARK: - Properties
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.backgroundColor = .white
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: UIScreen.main.bounds.height * 0.05,
            leading: 20,
            bottom: UIScreen.main.bounds.height * 0.05,
            trailing: 20
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 10
        return stackView
    }()
    private let makeGroupButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .mainOrange
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
    private let makeGroupImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "person.3.fill")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .white
        return imageView
    }()
    private let makeGroupDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "팀원들과 미니게임을 시작하려면"
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .white
        return label
    }()
    private let makeGroupTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "그룹 만들기"
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .white
        return label
    }()
    private let separatorLineView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .systemGray4
        return view
    }()
    private let pinNumberButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
    private let pinNumberImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "123.rectangle")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .black
        return imageView
    }()
    private let pinNumberDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "이미 생성된 그룹이 있다면"
        label.font = .preferredFont(forTextStyle: .title3)
        label.textColor = .black
        return label
    }()
    private let pinNumberTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "PIN으로 입장하기"
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .black
        return label
    }()
    
    private var viewModel: TogetherMenuViewModel!
    
    // MARK: - Initializers
    convenience init(viewModel: TogetherMenuViewModel) {
        self.init()
        self.viewModel = viewModel
        configureTabBar()
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    // MARK: - Methods
    private func configureTabBar() {
        tabBarItem.title = "함께 메뉴 결정"
        tabBarItem.image = UIImage(systemName: "person.3")
        tabBarItem.selectedImage = UIImage(systemName: "person.3.fill")
    }
    
    private func configureUI() {
        view.backgroundColor = .systemGray6
        view.addSubview(containerStackView)
        containerStackView.addArrangedSubview(makeGroupButton)
        containerStackView.addArrangedSubview(separatorLineView)
        containerStackView.addArrangedSubview(pinNumberButton)
        makeGroupButton.addSubview(makeGroupImageView)
        makeGroupButton.addSubview(makeGroupDescriptionLabel)
        makeGroupButton.addSubview(makeGroupTitleLabel)
        pinNumberButton.addSubview(pinNumberImageView)
        pinNumberButton.addSubview(pinNumberDescriptionLabel)
        pinNumberButton.addSubview(pinNumberTitleLabel)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            makeGroupButton.heightAnchor.constraint(equalTo: containerStackView.heightAnchor, multiplier: 0.5),

            makeGroupTitleLabel.heightAnchor.constraint(equalTo: makeGroupButton.heightAnchor, multiplier: 0.2),
            makeGroupTitleLabel.bottomAnchor.constraint(equalTo: makeGroupButton.bottomAnchor, constant: -5),
            makeGroupTitleLabel.trailingAnchor.constraint(equalTo: makeGroupButton.trailingAnchor, constant: -5),
            makeGroupDescriptionLabel.heightAnchor.constraint(equalTo: makeGroupButton.heightAnchor, multiplier: 0.1),
            makeGroupDescriptionLabel.bottomAnchor.constraint(equalTo: makeGroupTitleLabel.topAnchor, constant: 5),
            makeGroupDescriptionLabel.trailingAnchor.constraint(equalTo: makeGroupTitleLabel.trailingAnchor),
            makeGroupImageView.heightAnchor.constraint(equalTo: makeGroupButton.heightAnchor, multiplier: 0.5),
            makeGroupImageView.widthAnchor.constraint(equalTo: makeGroupImageView.heightAnchor),
            makeGroupImageView.bottomAnchor.constraint(equalTo: makeGroupDescriptionLabel.topAnchor, constant: 10),
            makeGroupImageView.trailingAnchor.constraint(equalTo: makeGroupDescriptionLabel.trailingAnchor),
            
            separatorLineView.heightAnchor.constraint(equalToConstant: 1),
            
            pinNumberButton.heightAnchor.constraint(equalTo: containerStackView.heightAnchor, multiplier: 0.3),

            pinNumberTitleLabel.heightAnchor.constraint(equalTo: pinNumberButton.heightAnchor, multiplier: 0.3),
            pinNumberTitleLabel.bottomAnchor.constraint(equalTo: pinNumberButton.bottomAnchor, constant: -10),
            pinNumberTitleLabel.leadingAnchor.constraint(equalTo: pinNumberButton.leadingAnchor, constant: 10),
            pinNumberDescriptionLabel.heightAnchor.constraint(equalTo: pinNumberButton.heightAnchor, multiplier: 0.1),
            pinNumberDescriptionLabel.bottomAnchor.constraint(equalTo: pinNumberTitleLabel.topAnchor, constant: 5),
            pinNumberDescriptionLabel.leadingAnchor.constraint(equalTo: pinNumberTitleLabel.leadingAnchor),
            pinNumberImageView.heightAnchor.constraint(equalTo: pinNumberButton.heightAnchor, multiplier: 0.3),
            pinNumberImageView.widthAnchor.constraint(equalTo: pinNumberImageView.heightAnchor),
            pinNumberImageView.trailingAnchor.constraint(equalTo: pinNumberButton.trailingAnchor, constant: -5),
            pinNumberImageView.bottomAnchor.constraint(equalTo: pinNumberButton.bottomAnchor, constant: -30),
        ])
    }
}

// MARK: - Rx Binding Methods
extension TogetherMenuViewController {
    private func bind() {
        let input = TogetherMenuViewModel.Input(
            makeGroupButtonDidTap: makeGroupButton.rx.tap.asObservable(),
            pinNumberButtonDidTap: pinNumberButton.rx.tap.asObservable()
        )
        
        viewModel.transform(input)
    }
}
