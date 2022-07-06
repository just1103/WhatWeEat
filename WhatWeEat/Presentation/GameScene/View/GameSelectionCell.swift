import UIKit

class GameSelectionCell: UICollectionViewCell {
    // MARK: - Properties
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Design.descriptionLabelFont
        label.textColor = .black
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    
    // MARK: - Initializers
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        descriptionLabel.text = nil
    }
    
    // MARK: - Methods
    func apply(isChecked: Bool, descriptionText: String) {
        if isChecked {
            toggleSelectedCellUI()
        }
        descriptionLabel.text = descriptionText
    }
    
    func toggleSelectedCellUI() {
        if self.backgroundColor == .subYellow {
            self.backgroundColor = .mainYellow
        } else {
            self.backgroundColor = .subYellow
        }
    }
    
    private func configureUI() {
        self.backgroundColor = Design.cellBackgroundColor
        self.layer.cornerRadius = Design.cellCornerRadius
        self.clipsToBounds = true
        
        addSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            descriptionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            descriptionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}

// MARK: - NameSpaces
extension GameSelectionCell {
    private enum Design {
        static let descriptionLabelFont: UIFont = .pretendard(family: .medium, size: 20)
        static let descriptionLabelTextColor: UIColor = .black
        static let cellBackgroundColor: UIColor = .subYellow
        static let cellCornerRadius: CGFloat = 8
    }
}
