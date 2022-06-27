import UIKit
import RxCocoa
import RxSwift

class NetworkErrorViewController: UIViewController {
    // MARK: - Properties
    private let backgroundView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        return view
    }()
    private let errorImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = UIImage(systemName: "wifi.slash")
        imageView.contentMode = .scaleAspectFit
        imageView.tintColor = .darkGray
        return imageView
    }()
    private let errorTitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "네트워크 연결 상태를 확인해주세요"
        label.font = .pretendard(family: .medium, size: 30)
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.textAlignment = .center
        return label
    }()
    private let retryButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(systemName: "arrow.clockwise.circle"), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.setPreferredSymbolConfiguration(UIImage.SymbolConfiguration(pointSize: 40), forImageIn: .normal)
        button.tintColor = .darkGray
        return button
    }()
    
    private var viewModel: NetworkErrorViewModel!
    
    convenience init(viewModel: NetworkErrorViewModel) {
        self.init(nibName: nil, bundle: nil)
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bind()
    }
    
    private func configureUI() {
        view.backgroundColor = .systemGray6
        view.addSubview(backgroundView)
        view.addSubview(errorImageView)
        view.addSubview(errorTitleLabel)
        view.addSubview(retryButton)
        
        NSLayoutConstraint.activate([
            backgroundView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            backgroundView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            errorTitleLabel.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            errorTitleLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            errorTitleLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            
            errorImageView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.2),
            errorImageView.widthAnchor.constraint(equalTo: errorImageView.heightAnchor),
            errorImageView.bottomAnchor.constraint(equalTo: errorTitleLabel.topAnchor, constant: -60),
            errorImageView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            
            retryButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor),
            retryButton.topAnchor.constraint(equalTo: errorTitleLabel.bottomAnchor),
            retryButton.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.15),
            retryButton.widthAnchor.constraint(equalTo: retryButton.heightAnchor),
        ])
    }
}

// MARK: - Rx Binding Methods
extension NetworkErrorViewController {
    private func bind() {
        let input = NetworkErrorViewModel.Input(retryButtonDidTap: retryButton.rx.tap.asObservable())
        
        viewModel.transform(input)
    }
}
