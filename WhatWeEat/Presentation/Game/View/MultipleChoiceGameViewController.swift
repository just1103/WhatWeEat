import RxCocoa
import RxSwift
import UIKit

class MultipleChoiceGameViewController: UIViewController {
    // MARK: - Nested Types
    private enum QuestionKind {
        case menuNation
        case mainIngredient
        
        var columnCount: Int {
            switch self {
            case .menuNation:
                return 2
            case .mainIngredient:
                return 1
            }
        }
    }
    
    // MARK: - Properties
    private let previousQuestionButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("이전 질문", for: .normal)
        button.setTitleColor(Design.previousQuestionButtonTitleColor, for: .normal)
        button.setImage(UIImage(systemName: "arrow.uturn.backward.circle"), for: .normal)
        button.tintColor = .black
        button.titleLabel?.font = .preferredFont(forTextStyle: .body)
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 0)
        button.contentHorizontalAlignment = .leading
        return button
    }()
    private let pinNumberLabel: UILabel = {  // TODO: 탭바버튼 종류에 따라 isHidden 처리
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .black
        label.font = .preferredFont(forTextStyle: .body)
        label.text = "PIN NUMBER : 1111"
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "어떤 게 끌리세요?"
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .largeTitle)
        return label
    }()
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "(중복 선택 가능)"
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()
    private let skipAndNextButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("뭐든 상관없음", for: .normal)
        button.setTitleColor(Design.skipAndConfirmButtonTitleColor, for: .normal)
        button.titleLabel?.font = Design.skipAndConfirmButtonTitleFont
        button.backgroundColor = Design.skipAndConfirmButtonBackgroundColor
        button.titleEdgeInsets = UIEdgeInsets(top: 15, left: 0, bottom: 30, right: 0)
        return button
    }()
    private let choiceCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private let invokedViewDidLoad = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    private var viewModel: MultipleChoiceGameViewModel!
    
    // MARK: - Initializers
    convenience init(viewModel: MultipleChoiceGameViewModel) {
        self.init()
        self.viewModel = viewModel
    }
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationBar()
        configureUI()
        configureCollectionView()
        bind()
        invokedViewDidLoad.onNext(())
    }
    
    // MARK: - Methods
    private func configureNavigationBar() {
        navigationItem.hidesBackButton = true
    }
    
    private func configureUI() {
//        mainIngredientCollectionView.isHidden = true
        view.addSubview(previousQuestionButton)
        view.addSubview(pinNumberLabel)
        view.addSubview(titleLabel)
        view.addSubview(subtitleLabel)
        view.addSubview(choiceCollectionView)
//        view.addSubview(menuNationCollectionView)
//        view.addSubview(mainIngredientCollectionView)
        view.addSubview(skipAndNextButton)
        
        NSLayoutConstraint.activate([
            previousQuestionButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            previousQuestionButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 15),
            previousQuestionButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.5),
            
            pinNumberLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15),
            pinNumberLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -15),
            
            titleLabel.topAnchor.constraint(equalTo: previousQuestionButton.bottomAnchor, constant: 30),
            titleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            subtitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            choiceCollectionView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
            choiceCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            choiceCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            choiceCollectionView.bottomAnchor.constraint(equalTo: skipAndNextButton.topAnchor, constant: -20),
            
//            mainIngredientCollectionView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 20),
//            mainIngredientCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            mainIngredientCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            mainIngredientCollectionView.bottomAnchor.constraint(equalTo: skipAndNextButton.topAnchor, constant: -20),
            
            skipAndNextButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            skipAndNextButton.widthAnchor.constraint(equalToConstant: UIScreen.main.bounds.width),
            skipAndNextButton.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.height * 0.09),
            skipAndNextButton.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    private func configureCollectionView() {
        choiceCollectionView.collectionViewLayout = createLayout(for: .menuNation)
        choiceCollectionView.translatesAutoresizingMaskIntoConstraints = false
        choiceCollectionView.backgroundColor = .white
        choiceCollectionView.register(cellType: GameSelectionCell.self)
//        menuNationCollectionView.collectionViewLayout = createLayout(for: .menuNation)
//        mainIngredientCollectionView.collectionViewLayout = createLayout(for: .mainIngredient)
//
//        menuNationCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        mainIngredientCollectionView.translatesAutoresizingMaskIntoConstraints = false
//        menuNationCollectionView.backgroundColor = .white
//        mainIngredientCollectionView.backgroundColor = .white
    }
    
    private func createLayout(for questionKind: QuestionKind) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(0.2))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: questionKind.columnCount)
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
        
        return layout
    }
    
}

// MARK: - Rx Binding Methods
extension MultipleChoiceGameViewController {
    private func bind() {
        let input = MultipleChoiceGameViewModel.Input(
            invokedViewDidLoad: invokedViewDidLoad.asObservable(),
            cellDidSelect: choiceCollectionView.rx.itemSelected.asObservable())
        let ouput = viewModel.transform(input)
        
        configureChoiceCollectionView(with: ouput.menuNations)
        configureSelectedCellAndSkipButton(at: ouput.selectedIndexPathAndCount)
    }
    
    private func configureChoiceCollectionView(with menuNations: Observable<[MenuNation]>) {
        menuNations
            .observe(on: MainScheduler.instance)
            .bind(to: choiceCollectionView.rx.items(
                cellIdentifier: String(describing: GameSelectionCell.self), cellType: GameSelectionCell.self
            )) { _, item, cell in
                cell.apply(isChecked: item.isChecked, descriptionText: item.descriptionText)
            }
            .disposed(by: disposeBag)
    }
    
    private func configureSelectedCellAndSkipButton(at indexPath: Observable<(IndexPath, Int)>) {
        indexPath
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { (self, selectedInformation) in
                let (indexPath, selectedCount) = selectedInformation
                guard let selectedCell = self.choiceCollectionView.cellForItem(at: indexPath) as? GameSelectionCell else { return }
                selectedCell.toggleSelectedCellUI()
                
                if selectedCount != .zero {
                    self.skipAndNextButton.setTitle("다음 질문", for: .normal)
                } else {
                    self.skipAndNextButton.setTitle("뭐든 상관없음", for: .normal)
                }
            })
            .disposed(by: disposeBag)
    }
}

extension MultipleChoiceGameViewController {
    private enum Design {
        static let previousQuestionButtonTitleColor: UIColor = .label
        static let skipAndConfirmButtonBackgroundColor: UIColor = ColorPalette.mainYellow
        static let skipAndConfirmButtonTitleColor: UIColor = .label
        static let skipAndConfirmButtonTitleFont: UIFont = .preferredFont(forTextStyle: .headline)
    }
}
