import UIKit

// TODO: 진행상태 bar 추가
final class MultipleChoiceCardView: UIView, CardViewProtocol {
    // MARK: - Nested Types
    enum QuestionKind {
        case menuNation, mainIngredient
        
        var columnCount: Int {
            switch self {
            case .menuNation:
                return Content.menuNationColumnCount
            case .mainIngredient:
                return Content.mainIngredientColumnCount
            }
        }
        
        var backgroundColor: UIColor {  // TODO: 무난한색깔 2개로 변경
            switch self {
            case .menuNation:
                return Design.menuNationBackgroundColor
            case .mainIngredient:
                return Design.mainIngredientBackgroundColor
            }
        }
        
        var sectionInset: NSDirectionalEdgeInsets {
            switch self {
            case .menuNation:
                return Design.menuNationSectionInsets
            case .mainIngredient:
                return Design.mainIngredientSectionInsets
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
        stackView.directionalLayoutMargins = Design.containerStackViewMargins
        stackView.isLayoutMarginsRelativeArrangement = true
        stackView.spacing = Design.containerStackViewSpacing
        stackView.backgroundColor = .black
        stackView.layer.cornerRadius = Design.containerStackViewCornerRadius
        stackView.clipsToBounds = true
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Text.titleLabelText
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        label.textAlignment = .center
        label.font = Design.titleLabelFont
        label.textColor = Design.titleLabelTextColor
        return label
    }()
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = Text.subtitleLabelText
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        label.textAlignment = .center
        label.font = Design.subtitleLabelFont
        label.textColor = Design.subtitleLabelTextColor
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
            item.contentInsets = Design.collectionViewItemInsets
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

// MARK: - Namespaces
extension MultipleChoiceCardView {
    private enum Design {
        static let menuNationBackgroundColor: UIColor = .darkGray
        static let mainIngredientBackgroundColor: UIColor = .systemGray
        static let menuNationSectionInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
        static let mainIngredientSectionInsets = NSDirectionalEdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 30)
        static let containerStackViewMargins = NSDirectionalEdgeInsets(top: 15, leading: 5, bottom: 10, trailing: 5)
        static let containerStackViewSpacing: CGFloat = 10
        static let containerStackViewCornerRadius: CGFloat = UIScreen.main.bounds.height * 0.1 * 0.5
        static let titleLabelFont: UIFont = .pretendardDefaultSize(family: .bold)
        static let titleLabelTextColor: UIColor = .white
        static let subtitleLabelFont: UIFont = .pretendard(family: .medium, size: 30)
        static let subtitleLabelTextColor: UIColor = .white
        static let collectionViewItemInsets = NSDirectionalEdgeInsets(top: 5, leading: 10, bottom: 5, trailing: 10)
    }

    private enum Content {
        static let menuNationColumnCount = 2
        static let mainIngredientColumnCount = 1
    }
    
    private enum Text {
        static let titleLabelText = "어떤 게 끌리세요?"
        static let subtitleLabelText = "(중복 선택 가능)"
    }
}
