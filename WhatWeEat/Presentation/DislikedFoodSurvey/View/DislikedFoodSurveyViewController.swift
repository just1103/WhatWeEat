import UIKit

final class DislikedFoodSurveyViewController: UIViewController {
    // MARK: - Nested Types
    private enum SectionKind: Int {
        case main
        
        var columnCount: Int {
            switch self {
            case .main:
                return 2
            }
        }
    }
    
    // MARK: - Properties
    let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 20
        return stackView
    }()
    let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "못먹는 음식을 알려주세요"
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    let confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("확인", for: .normal)
        button.titleLabel?.font = .preferredFont(forTextStyle: .title2)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = ColorPalette.mainYellow
        button.titleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 20, right: 0)
        button.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width).isActive = true
        button.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.09).isActive = true
        return button
    }()
    
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIOSVersion()
        configureCollectionView()
        configureStackView()
    }
    
    // MARK: - Methods
    private func checkIOSVersion() {
        let versionNumbers = UIDevice.current.systemVersion.components(separatedBy: ".")
        let major = versionNumbers[0]
        let minor = versionNumbers[1]
        let version = major + "." + minor
        
        guard let systemVersion = Double(version) else { return }
        let errorVersion = 15.0..<15.4
        // 해당 버전만 is stuck in its update/layout loop. 에러가 발생하여 Alert로 업데이트 권고
        if  errorVersion ~= systemVersion {
            showErrorVersionAlert()
        }
    }
    
    private func showErrorVersionAlert() {
        let okAlertAction = UIAlertAction(title: Content.okAlertActionTitle, style: .default)
        let alert = AlertFactory().createAlert(title: Content.versionErrorTitle, message: nil, actions: okAlertAction)
        present(alert, animated: true)
    }
    
    private func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let layout = createLayout()
        collectionView.collectionViewLayout = layout
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let sectionKind = SectionKind(rawValue: sectionIndex) else {
                self?.showUnknownSectionErrorAlert()
                return nil
            }
            let screenWidth = UIScreen.main.bounds.width
            let estimatedHeight = NSCollectionLayoutDimension.estimated(screenWidth)
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: estimatedHeight)
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: estimatedHeight)
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: sectionKind.columnCount)
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
        
        return layout
    }
    
    private func showUnknownSectionErrorAlert() {
        let okAlertAction = UIAlertAction(title: Content.okAlertActionTitle, style: .default)
        let alert = AlertFactory().createAlert(title: Content.unknownSectionErrorTitle, actions: okAlertAction)
        present(alert, animated: true)
    }
    
    private func configureStackView() {
        view.backgroundColor = .white // TODO: 나중에 삭제
        view.addSubview(containerStackView)
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(collectionView)
        containerStackView.addArrangedSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            containerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
}

// MARK: - NameSpaces
extension DislikedFoodSurveyViewController {
    private enum Content {
        static let unknownSectionErrorTitle = "알 수 없는 Section입니다"
        static let okAlertActionTitle = "OK"
        static let versionErrorTitle = "기기를 iOS 15.4 이상으로 업데이트 해주세요"
    }
}
