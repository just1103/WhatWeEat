import UIKit

// TODO: Cell 간에 내부 여백주기 (가로, 세로 줄이고)
// 체크박스 크기 작게 (텍스트 크기만큼)

// 진행상태 bar를 주는게 낫겠다
// Cell 위에 체크박스 있는 것보다 없는게 나을듯, 색깔만 들어가도 사용자가 선택됨을 알수있음
final class MultipleChoiceCardView: UIView, CardViewProtocol {
    // MARK: - Nested Types
    enum QuestionKind {
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
        
        var backgroundColor: UIColor {  // TODO: 무난한색깔 2개로 변경
            switch self {
            case .menuNation:
                return .darkGray
            case .mainIngredient:
                return .systemGray
            }
        }
        
        var sectionInset: NSDirectionalEdgeInsets {
            switch self {
            case .menuNation:
                return NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
            case .mainIngredient:
                return NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30)
            }
        }
    }
    
    // MARK: - Properties
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 15, leading: 5, bottom: 10, trailing: 5)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 10
        stackView.backgroundColor = .black
        stackView.layer.cornerRadius = UIScreen.main.bounds.height * 0.1 * 0.5
        stackView.clipsToBounds = true
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "어떤 게 끌리세요?"
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textColor = .white
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
        label.textColor = .white
        return label
    }()
    let choiceCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    
    // MARK: - Initializers
    convenience init(title: String, subtitle: String) {
        self.init(frame: .zero)
        configureUI()
        configureLabelText(title: title, subtitle: subtitle)
        configureCollectionView()
    }
    
    // MARK: - Methods
    func changeCollectionViewUI(for questionKind: QuestionKind) {
        choiceCollectionView.collectionViewLayout = createLayout(for: questionKind)
        changeBackgroundColor(for: questionKind)
    }
    
    private func createLayout(for questionKind: QuestionKind) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(0.8),
                heightDimension: .fractionalHeight(1.0)
            )
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.22)
            ) // TODO: 화면 크기에 따라 변경
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: questionKind.columnCount)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = questionKind.sectionInset
            
            return section
        }
        
        return layout
    }
    
    private func changeBackgroundColor(for questionKind: QuestionKind) {
        choiceCollectionView.backgroundColor = questionKind.backgroundColor
        containerStackView.backgroundColor = questionKind.backgroundColor
    }
    
    func configureUI() {
        self.backgroundColor = UIColor.clear
//        self.applyShadow(direction: .top, radius: 8)
        
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(titleLabel)
        containerStackView.addArrangedSubview(subtitleLabel)
        containerStackView.addArrangedSubview(choiceCollectionView)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: self.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }
    
    private func configureLabelText(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    private func configureCollectionView() {
        choiceCollectionView.collectionViewLayout = createLayout(for: .menuNation)
        choiceCollectionView.translatesAutoresizingMaskIntoConstraints = false
        choiceCollectionView.backgroundColor = .black
        choiceCollectionView.register(cellType: GameSelectionCell.self)
    }
}
