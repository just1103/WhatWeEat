import UIKit
import RxSwift
import RxCocoa

// TODO: Cell을 타일 형태로 변경 (행끼리 붙어있게)
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
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Text.titleLabelText
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        label.textAlignment = .left
        label.font = Design.titleLabelFont
        label.textColor = Design.titleLabelTextColor
        return label
    }()
    private let titleDescriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Text.titleDescriptionLabelText
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        label.textAlignment = .left
        label.font = Design.titleDescriptionLabelFont
        label.textColor = Design.titleDescriptionLabelTextColor
        return label
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Text.descriptionLabelText
        label.lineBreakStrategy = .hangulWordPriority
        label.textAlignment = .left
        label.font = Design.descriptionLabelFont
        label.textColor = Design.descriptionLabelTextColor
        return label
    }()
    private let confirmButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(Text.confirmButtonTitle, for: .normal)
        button.titleLabel?.font = Design.confirmButtonFont
        button.setTitleColor(Design.confirmButtonTitleColor, for: .normal)
        button.backgroundColor = Design.confirmButtonBackgroundColor
        button.titleEdgeInsets = Design.confirmButtonTitleEdgeInsets
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
        guard
            let major = versionNumbers[safe: 0],
            let minor = versionNumbers[safe: 1]
        else { return }
        
        let version = major + "." + minor
        
        guard let systemVersion = Double(version) else { return }
        let errorVersion = 15.0..<15.4
        // 해당 버전만 is stuck in its update/layout loop. 에러가 발생하여 Alert로 업데이트 권고
        if  errorVersion ~= systemVersion {
            showErrorVersionAlert()
        }
    }
    
    private func showErrorVersionAlert() {
        let okAlertAction = UIAlertAction(title: Text.okAlertActionTitle, style: .default)
        let alert = AlertFactory().createAlert(title: Text.versionErrorTitle, message: nil, actions: okAlertAction)
        present(alert, animated: true)
    }
    
    private func configureNavigationBar() {
        navigationItem.hidesBackButton = true
    }
    
    private func configureCollectionView() {
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        let layout = createLayout()
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = Design.collectionViewBackgroundColor
    }
    
    private func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { [weak self] sectionIndex, _ -> NSCollectionLayoutSection? in
            guard let sectionKind = SectionKind(rawValue: sectionIndex) else {
                self?.showUnknownSectionErrorAlert()
                return nil
            }
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = Design.collectionViewItemInset
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.4))
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
        let okAlertAction = UIAlertAction(title: Text.okAlertActionTitle, style: .default)
        let alert = AlertFactory().createAlert(title: Text.unknownSectionErrorTitle, actions: okAlertAction)
        present(alert, animated: true)
    }
    
    private func configureStackView() {
        view.addSubview(titleLabel)
        view.addSubview(titleDescriptionLabel)
        view.addSubview(descriptionLabel)
        view.addSubview(collectionView)
        view.addSubview(confirmButton)

        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: Constraint.titleLabelTopAnchorConstant
            ),
            titleLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constraint.titleLabelLeadingAnchorConstant
            ),
            
            titleDescriptionLabel.bottomAnchor.constraint(equalTo: titleLabel.bottomAnchor),
            titleDescriptionLabel.leadingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor,
                constant: Constraint.titleDescriptionLabelLeadingAnchorConstant
            ),
            titleDescriptionLabel.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: Constraint.titleDescriptionLabelTrailingAnchorConstant),
            
            descriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
            descriptionLabel.leadingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.leadingAnchor,
                constant: Constraint.descriptionLabelHorizontalConstant
            ),
            descriptionLabel.trailingAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.trailingAnchor,
                constant: Constraint.descriptionLabelHorizontalConstant
            ),
            
            collectionView.topAnchor.constraint(
                equalTo: descriptionLabel.bottomAnchor,
                constant: Constraint.collectionViewTopAnchorConstant
            ),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(
                equalTo: confirmButton.topAnchor,
                constant: Constraint.collectionViewBottomAnchorConstant
            ),
            
            confirmButton.widthAnchor.constraint(
                equalToConstant: Constraint.confirmButtonWidthAnchorConstant
            ),
            confirmButton.heightAnchor.constraint(
                equalToConstant: Constraint.confirmButtonHeightAnchorConstant
            ),
            confirmButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
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

    private func configureItems(with outputObservable: Observable<[DislikedFood]>) {
        outputObservable
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (owner, dislikedFoods) in
                owner.configureInitialSnapshot(with: dislikedFoods)
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
            .withUnretained(self)
            .observe(on: MainScheduler.instance)
            .subscribe(onNext: { (owner, indexPath) in
                guard let selectedCell = owner.collectionView.cellForItem(at: indexPath) as? DislikedFoodCell else { return }
                selectedCell.toggleSelectedCellUI()
            })
            .disposed(by: disposeBag)
    }
}

// MARK: - NameSpaces
extension DislikedFoodSurveyViewController {
    private enum Design {
        static let titleLabelFont: UIFont = .pretendard(family: .bold, size: 40)
        static let titleLabelTextColor: UIColor = .black
        static let titleDescriptionLabelFont: UIFont = .pretendard(family: .bold, size: 25)
        static let titleDescriptionLabelTextColor: UIColor = .black
        static let descriptionLabelFont: UIFont = .pretendard(family: .medium, size: 22)
        static let descriptionLabelTextColor: UIColor = .black
        static let confirmButtonFont: UIFont = .pretendard(family: .medium, size: 25)
        static let confirmButtonTitleEdgeInsets = UIEdgeInsets(top: 5, left: 0, bottom: 20, right: 0)
        static let confirmButtonTitleColor: UIColor = .black
        static let confirmButtonBackgroundColor: UIColor = .mainYellow
        static let collectionViewItemInset = NSDirectionalEdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0)
        static let collectionViewBackgroundColor: UIColor = .white
    }
    
    private enum Constraint {
        static let titleLabelTopAnchorConstant: CGFloat = 30
        static let titleLabelLeadingAnchorConstant: CGFloat = 20
        static let titleDescriptionLabelLeadingAnchorConstant: CGFloat = 2
        static let titleDescriptionLabelTrailingAnchorConstant: CGFloat = -15
        static let descriptionLabelHorizontalConstant: CGFloat = 20
        static let collectionViewTopAnchorConstant: CGFloat = 40
        static let collectionViewBottomAnchorConstant: CGFloat = -30
        static let confirmButtonWidthAnchorConstant: CGFloat = UIScreen.main.bounds.width
        static let confirmButtonHeightAnchorConstant: CGFloat = UIScreen.main.bounds.height * 0.09
    }
    
    private enum Text {
        static let unknownSectionErrorTitle = "알 수 없는 Section입니다"
        static let okAlertActionTitle = "OK"
        static let versionErrorTitle = "기기를 iOS 15.4 이상으로 업데이트 해주세요"
        static let titleLabelText = "못먹는 음식"
        static let titleDescriptionLabelText = "을 알려주세요"
        static let descriptionLabelText = "메뉴에서 제외하고 추천드려요"
        static let confirmButtonTitle = "확인"
    }
}
