import UIKit

class SettingDetailViewController: UIViewController {
    // MARK: - Properties
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = Design.textViewFont
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.dataDetectorTypes = .all
        textView.textContainerInset = Design.textViewContentInsets
        textView.isEditable = false
        return textView
    }()
    
    private var viewModel: SettingDetailViewModel!
    private var settingTitle: String = Text.initialSettingTitle
    private var content: String = Text.initialContent
    
    // MARK: - Initializers
    convenience init(viewModel: SettingDetailViewModel, title: String, content: String) {
        self.init()
        self.viewModel = viewModel
        self.settingTitle = title
        self.content = content
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureUI()
        bind()
    }
    
    // MARK: - Methods
    private func configureNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: Content.backButtonImage,
            style: .plain,
            target: self,
            action: nil
        )
        navigationItem.leftBarButtonItem?.tintColor = Design.backButtonTintColor
        navigationItem.title = settingTitle
    }
    
    private func configureUI() {
        view.addSubview(textView)
        view.backgroundColor = Design.backgroundColor
        textView.text = content
        textView.setContentOffset(.zero, animated: false)
        textView.layoutIfNeeded()
        
        NSLayoutConstraint.activate([
            textView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            textView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}

// MARK: - Rx Binding Methods
extension SettingDetailViewController {
    private func bind() {
        guard let leftBarButtonItem = navigationItem.leftBarButtonItem else { return }
        let input = SettingDetailViewModel.Input(backButtonDidTap: leftBarButtonItem.rx.tap.asObservable())
        
        viewModel.transform(input)
    }
}

extension SettingDetailViewController {
    private enum Design {
        static let textViewFont: UIFont = .pretendard(family: .medium, size: 15)
        static let textViewContentInsets = UIEdgeInsets(top: 30, left: 10, bottom: 10, right: 10)
        static let backButtonTintColor: UIColor = .black
        static let backgroundColor: UIColor = .systemGray6
    }
    
    private enum Content {
        static let backButtonImage = UIImage(systemName: "arrow.backward")
    }
    
    private enum Text {
        static let initialSettingTitle = ""
        static let initialContent = ""
    }
}
