import UIKit
import SwiftUI

class VersionCell: UITableViewCell {
    // MARK: - Properties
    private let containerStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fill
        return stackView
    }()
    private let titleStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.distribution = .fillEqually
        return stackView
    }()
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = Design.titleLabelFont
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = Design.subtitleLabelFont
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.textColor = Design.subtilteLabelTextColor
        return label
    }()
    private let versionStatusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        button.backgroundColor = Design.versionStatusButtonBackgroundColor
        button.setTitleColor(Design.versionStatusButtonTitleColor, for: .normal)
        button.titleLabel?.font = Design.versionStatusButtonTitleFont
        return button
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
    
    // MARK: - LifeCycle Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        versionStatusButton.setTitle(nil, for: .normal)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
//        self.backgroundColor = ColorPalette.subYellow
    }
    
    // MARK: - Methods
    func apply(title: String, subtitle: String, buttonTitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        versionStatusButton.setTitle(buttonTitle, for: .normal)
    }
    
    private func configureUI() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(titleStackView)
        containerStackView.addArrangedSubview(versionStatusButton)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 5),
            containerStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            containerStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            containerStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -5),
        ])
    }
}

// MARK: - NameSpace
extension VersionCell {
    private enum Design {
        static let titleLabelFont: UIFont = .preferredFont(forTextStyle: .title3)
        
        static let subtitleLabelFont: UIFont = .preferredFont(forTextStyle: .body)
        static let subtilteLabelTextColor: UIColor = .systemGray
        
        static let versionStatusButtonTitleColor: UIColor = .black
        static let versionStatusButtonTitleFont: UIFont = .preferredFont(forTextStyle: .body)
        static let versionStatusButtonBackgroundColor = ColorPalette.mainYellow
    }
}
