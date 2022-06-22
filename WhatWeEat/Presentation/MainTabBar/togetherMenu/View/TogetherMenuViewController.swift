import UIKit

final class TogetherMenuViewController: UIViewController, TabBarContentProtocol {
    // MARK: - Properties
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalCentering
        stackView.backgroundColor = .white
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(
            top: UIScreen.main.bounds.height * 0.15,
            leading: 40,
            bottom: UIScreen.main.bounds.height * 0.15,
            trailing: 40
        )
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let makeGroupButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("팀원들과 미니게임을 시작하려면\n그룹 만들기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = ColorPalette.mainYellow
        button.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
    }()
    private let pinNumberButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("이미 생성된 그룹이 있다면\nPIN으로 입장하기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = ColorPalette.mainYellow
        button.titleLabel?.font = .preferredFont(forTextStyle: .largeTitle)
        button.layer.cornerRadius = 5
        button.clipsToBounds = true
        return button
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
        view.backgroundColor = ColorPalette.mainYellow
        view.addSubview(containerStackView)
        containerStackView.addArrangedSubview(makeGroupButton)
        containerStackView.addArrangedSubview(pinNumberButton)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            
            makeGroupButton.heightAnchor.constraint(equalTo: containerStackView.heightAnchor, multiplier: 0.2),
            makeGroupButton.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor, constant: 50),
            makeGroupButton.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor, constant: -50),
            
            pinNumberButton.heightAnchor.constraint(equalTo: containerStackView.heightAnchor, multiplier: 0.2),
            pinNumberButton.leadingAnchor.constraint(equalTo: containerStackView.leadingAnchor, constant: 50),
            pinNumberButton.trailingAnchor.constraint(equalTo: containerStackView.trailingAnchor, constant: -50),
        ])
    }
}

// MARK: - Rx Binding Methods
extension TogetherMenuViewController {
    private func bind() {
        let input = TogetherMenuViewModel.Input(makeGroupButtonDidTap: makeGroupButton.rx.tap.asObservable())
        
        viewModel.transform(input)
    }
}
