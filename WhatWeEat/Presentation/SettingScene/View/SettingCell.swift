import UIKit

class SettingCell: UITableViewCell {
    // MARK: - Properties
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = Design.titleLabelFont
        label.textColor = Design.titleLabelTextColor
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
    }
    
    // MARK: - Methods
    func apply(title: String) {
        titleLabel.text = title
    }
    
    private func configureUI() {
        backgroundColor = Design.backgroundColor
        accessoryType = .disclosureIndicator  // TODO: 다크모드에서 색상이 연하므로 accessoryView를 chevron.right 이미지의 Button으로 교체
        selectionStyle = .none
        
        addSubview(titleLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            titleLabel.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -60),
            titleLabel.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 15),
            titleLabel.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -15),
        ])
    }
}

// MARK: - NameSpaces
extension SettingCell {
    private enum Design {
        static let backgroundColor: UIColor = .white
        static let titleLabelFont: UIFont = .pretendard(family: .regular, size: 20)
        static let titleLabelTextColor: UIColor = .black
    }
}
