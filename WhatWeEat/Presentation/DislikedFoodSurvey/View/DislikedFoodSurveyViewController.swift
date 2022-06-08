import UIKit
import RxSwift
import RxCocoa

final class DislikedFoodSurveyViewController: UIViewController, OnboardingContentProtocol {
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
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 20
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "못먹는 음식을 알려주세요"
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    private let confirmButton: UIButton = {
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
    
    private var viewModel: DislikedFoodSurveyViewModel!
    private var collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private var dataSource: DiffableDataSource!
    private var snapshot: NSDiffableDataSourceSnapshot<SectionKind, DislikedFood>!
    private let invokedViewDidLoad = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    private typealias CellRegistration = UICollectionView.CellRegistration<DislikedFoodCell, DislikedFood>
    private typealias DiffableDataSource = UICollectionViewDiffableDataSource<SectionKind, DislikedFood>
    
    // MARK: - Initializers
    convenience init(viewModel: DislikedFoodSurveyViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        checkIOSVersion()
        configureNavigationBar()
        configureCollectionView()
        configureStackView()
        configureCellRegistrationAndDataSource()
        bind()
        invokedViewDidLoad.onNext(())
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
    
    private func configureNavigationBar() {
        navigationItem.hidesBackButton = true
    }
    
    private func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let layout = createLayout()
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .white
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let sectionKind = SectionKind(rawValue: sectionIndex) else {
                self?.showUnknownSectionErrorAlert()
                return nil
            }
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.3))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: sectionKind.columnCount)
            let section = NSCollectionLayoutSection(group: group)

            return section
        }

        return layout
    }
    
    private func configureCellRegistrationAndDataSource() {
        let cellRegistration = CellRegistration { cell, _, dislikedFood in
            cell.apply(
                isChecked: dislikedFood.isChecked,
                descriptionImage: dislikedFood.descriptionImage,
                descriptionText: dislikedFood.descriptionText
            )
        }
        
        dataSource = DiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, dislikedFood in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: dislikedFood)
        })
    }
    
    private func showUnknownSectionErrorAlert() {
        let okAlertAction = UIAlertAction(title: Content.okAlertActionTitle, style: .default)
        let alert = AlertFactory().createAlert(title: Content.unknownSectionErrorTitle, actions: okAlertAction)
        present(alert, animated: true)
    }
    
    private func configureStackView() {
        view.addSubview(containerStackView)
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(collectionView)
        containerStackView.addArrangedSubview(confirmButton)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30),
            containerStackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor, multiplier: 0.9)
        ])
    }
}

// MARK: - Rx binding Methods
extension DislikedFoodSurveyViewController {
    private func bind() {
        let input = DislikedFoodSurveyViewModel.Input(
            invokedViewDidLoad: invokedViewDidLoad.asObservable(),
            cellDidSelect: collectionView.rx.itemSelected.asObservable(),
            confirmButtonDidTap: confirmButton.rx.tap.asObservable()
        )
        
        let output = viewModel.transform(input)
        
        configureItems(with: output.dislikedFoods)
        configureSelectedCell(at: output.selectedFoodIndexPath)
    }

    private func configureItems(with dislikedFoods: Observable<[DislikedFood]>) {
        dislikedFoods
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] dislikedFoods in
                self?.configureInitialSnapshot(with: dislikedFoods)
            })
            .disposed(by: disposeBag)
    }
    
    private func configureInitialSnapshot(with dislikedFood: [DislikedFood]) {
        snapshot = NSDiffableDataSourceSnapshot<SectionKind, DislikedFood>()
        snapshot.appendSections([.main])
        snapshot.appendItems(dislikedFood)
        dataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func configureSelectedCell(at indexPath: Observable<IndexPath>) {
        indexPath
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { [weak self] indexPath in
                guard let selectedCell = self?.collectionView.cellForItem(at: indexPath) as? DislikedFoodCell else { return }
                selectedCell.toggleSelectedCellUI()
            })
            .disposed(by: disposeBag)
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
