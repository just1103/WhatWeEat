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
        button.titleLabel?.font = Design.versionStatusButtonTitleFont
        button.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
        button.setContentCompressionResistancePriority(.required, for: .horizontal)
        return button
    }()
    
    // MARK: - Initializers
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
        self.isUserInteractionEnabled = false
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle Methods
    override func prepareForReuse() {
        super.prepareForReuse()
        titleLabel.text = nil
        subtitleLabel.text = nil
        versionStatusButton.setTitle(nil, for: .normal)
        versionStatusButton.isUserInteractionEnabled = true
    }
    
    // MARK: - Methods
    func apply(title: String, subtitle: String, buttonTitle: String) {
        titleLabel.text = title
        subtitleLabel.text = subtitle
        versionStatusButton.setTitle(buttonTitle, for: .normal)
        setupVersionStatusButton()
    }
    
    private func setupVersionStatusButton() {
        if versionStatusButton.titleLabel?.text == Content.versionInformationButtonUpdateTitle {
            versionStatusButton.setTitleColor(Design.versionStatusButtonUpdateTitleColor, for: .normal)
            versionStatusButton.backgroundColor = .mainYellow
        } else {
            versionStatusButton.setTitleColor(Design.versionStatusButtonLatestTitleColor, for: .normal)
            versionStatusButton.backgroundColor = Design.versionStatusButtonLatestBackgroundColor
            versionStatusButton.isUserInteractionEnabled = false
        }
    }
    
    private func configureUI() {
        addSubview(containerStackView)
        containerStackView.addArrangedSubview(titleStackView)
        containerStackView.addArrangedSubview(versionStatusButton)
        titleStackView.addArrangedSubview(titleLabel)
        titleStackView.addArrangedSubview(subtitleLabel)
        
        NSLayoutConstraint.activate([
            containerStackView.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor, constant: 8),
            containerStackView.leadingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.leadingAnchor, constant: 30),
            containerStackView.trailingAnchor.constraint(equalTo: self.safeAreaLayoutGuide.trailingAnchor, constant: -10),
            containerStackView.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor, constant: -8),
            
            versionStatusButton.widthAnchor.constraint(equalTo: self.safeAreaLayoutGuide.widthAnchor, multiplier: 0.2)
        ])
    }
}

// MARK: - NameSpaces
extension VersionCell {
    private enum Design {
        static let titleLabelFont: UIFont = .preferredFont(forTextStyle: .title3)
        
        static let subtitleLabelFont: UIFont = .preferredFont(forTextStyle: .body)
        static let subtilteLabelTextColor: UIColor = .systemGray
        
        static let versionStatusButtonTitleFont: UIFont = .preferredFont(forTextStyle: .body)
        static let versionStatusButtonUpdateTitleColor: UIColor = .black
        static let versionStatusButtonLatestTitleColor: UIColor = .systemGray
        static let versionStatusButtonUpdateBackgroundColor: UIColor = .mainYellow
        static let versionStatusButtonLatestBackgroundColor: UIColor = .white
    }
    
    enum Content {
        static let versionInformationButtonUpdateTitle = "업데이트"
        static let versionInformationButtonLatestTitle = "최신버전"
    }
}
