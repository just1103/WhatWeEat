import UIKit

class GameSelectionCell: UICollectionViewCell {
    // MARK: - Properties
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.directionalLayoutMargins = NSDirectionalEdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5)
        stackView.isLayoutMarginsRelativeArrangement = true
        return stackView
    }()
    private let checkBoxImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.image = Content.uncheckedImage
        imageView.tintColor = .black
        imageView.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        return imageView
    }()
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Design.descriptionLabelFont
        label.numberOfLines = 0
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
        checkBoxImageView.image = nil
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
        if checkBoxImageView.image == Content.uncheckedImage {
            checkBoxImageView.image = Content.checkedImage
            self.backgroundColor = ColorPalette.mainYellow
        } else {
            checkBoxImageView.image = Content.uncheckedImage
            self.backgroundColor = ColorPalette.subYellow
        }
    }
    
    private func configureUI() {
        self.backgroundColor = ColorPalette.subYellow
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
        
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(checkBoxImageView)
        containerStackView.addArrangedSubview(descriptionLabel)

        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: self.topAnchor),
            containerStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            containerStackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            containerStackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            
            checkBoxImageView.widthAnchor.constraint(equalTo: containerStackView.widthAnchor, multiplier: 0.2),
            checkBoxImageView.heightAnchor.constraint(equalTo: checkBoxImageView.widthAnchor),
        ])
    }
}

// MARK: - NameSpaces
extension GameSelectionCell {
    private enum Design {
        static let descriptionLabelFont: UIFont = .preferredFont(forTextStyle: .headline)
    }
    
    private enum Content {
        static let checkedImage = UIImage(systemName: "checkmark.square")
        static let uncheckedImage = UIImage(systemName: "square")
    }
}
