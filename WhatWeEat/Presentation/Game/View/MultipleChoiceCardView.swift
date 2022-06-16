import UIKit

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
    }
    
    // MARK: - Properties
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = 10
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
        configureLayer()
        configureLabelText(title: title, subtitle: subtitle)
        configureCollectionView()
    }
    
    // MARK: - Methods
    func changeCollectionViewLayout(for questionKind: QuestionKind) {
        choiceCollectionView.collectionViewLayout = createLayout(for: questionKind)
    }
    
    func configureUI() {
        backgroundColor = .darkGray
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
    
    private func configureLayer() {
        layer.borderWidth = 2
        layer.borderColor = UIColor.black.cgColor
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    private func configureLabelText(title: String, subtitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
    }
    
    private func configureCollectionView() {
        choiceCollectionView.collectionViewLayout = createLayout(for: .menuNation)
        choiceCollectionView.translatesAutoresizingMaskIntoConstraints = false
        choiceCollectionView.backgroundColor = .darkGray
        choiceCollectionView.register(cellType: GameSelectionCell.self)
    }
    
    private func createLayout(for questionKind: QuestionKind) -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout { _, _ -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5)
            let groupSize = NSCollectionLayoutSize(
                widthDimension: .fractionalWidth(1.0),
                heightDimension: .fractionalHeight(0.25)
            ) // TODO: 화면 크기에 따라 변경 
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitem: item, count: questionKind.columnCount)
            let section = NSCollectionLayoutSection(group: group)
            
            return section
        }
        
        return layout
    }
}
