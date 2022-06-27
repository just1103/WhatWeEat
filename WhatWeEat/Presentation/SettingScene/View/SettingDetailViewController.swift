import UIKit

class SettingDetailViewController: UIViewController {
    // MARK: - Properties
    private let textView: UITextView = {
        let textView = UITextView()
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.font = .pretendard(family: .medium, size: 15)
        textView.textContainer.lineBreakMode = .byWordWrapping
        textView.dataDetectorTypes = .all
        textView.textContainerInset = UIEdgeInsets(top: 30, left: 10, bottom: 10, right: 10)
        textView.isEditable = false
        return textView
    }()
    
    private var viewModel: SettingDetailViewModel!
    private var settingTitle: String = ""
    private var content: String = ""
    
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
        let backButtonImage = UIImage(systemName: "arrow.backward")
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            image: backButtonImage,
            style: .plain,
            target: self,
            action: nil
        )
        navigationItem.leftBarButtonItem?.tintColor = .black
        navigationItem.title = settingTitle
    }
    
    private func configureUI() {
        view.addSubview(textView)
        view.backgroundColor = .systemGray6
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
