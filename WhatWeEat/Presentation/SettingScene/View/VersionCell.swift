import UIKit

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
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        return label
    }()
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.font = Design.subtitleLabelFont
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        label.textColor = Design.subtitleLabelTextColor
        return label
    }()
    // TODO: 다음 배포버전에서 추가 - 업데이트 버튼을 탭하면 AppStore 앱을 보여줌
    private let versionStatusButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = Design.versionStatusButtonCornerRadius
        button.titleLabel?.font = Design.versionStatusButtonTitleFont
        button.titleEdgeInsets = Design.versionStatusButtonTitleInsets
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
        if versionStatusButton.titleLabel?.text == Text.versionInformationButtonUpdateTitle {
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
            containerStackView.topAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.topAnchor,
                constant: Constraint.containerStackViewTopAnchorConstant
            ),
            containerStackView.leadingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.leadingAnchor,
                constant: Constraint.containerStackViewLeadingAnchorConstant
            ),
            containerStackView.trailingAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.trailingAnchor,
                constant: Constraint.containerStackViewTrailingAnchorConstant
            ),
            containerStackView.bottomAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.bottomAnchor,
                constant: Constraint.containerStackViewBottomAnchorConstant
            ),
            
            versionStatusButton.widthAnchor.constraint(
                equalTo: self.safeAreaLayoutGuide.widthAnchor,
                multiplier: Constraint.versionStatusButtonWidthAnchorMultiplier
            )
        ])
    }
}

// MARK: - NameSpaces
extension VersionCell {
    private enum Design {
        static let titleLabelFont: UIFont = .pretendard(family: .regular, size: 22)
        static let subtitleLabelFont: UIFont = .pretendard(family: .regular, size: 15)
        static let subtitleLabelTextColor: UIColor = .systemGray
        static let versionStatusButtonTitleFont: UIFont = .pretendard(family: .regular, size: 15)
        static let versionStatusButtonUpdateTitleColor: UIColor = .black
        static let versionStatusButtonLatestTitleColor: UIColor = .systemGray
        static let versionStatusButtonUpdateBackgroundColor: UIColor = .mainYellow
        static let versionStatusButtonLatestBackgroundColor: UIColor = .white
        static let versionStatusButtonCornerRadius: CGFloat = 28
        static let versionStatusButtonTitleInsets = UIEdgeInsets(top: 0, left: 2, bottom: 0, right: 2)
    }
    
    enum Constraint {
        static let containerStackViewTopAnchorConstant: CGFloat = 15
        static let containerStackViewLeadingAnchorConstant: CGFloat = 30
        static let containerStackViewTrailingAnchorConstant: CGFloat = -10
        static let containerStackViewBottomAnchorConstant: CGFloat = -15
        static let versionStatusButtonWidthAnchorMultiplier = 0.25
    }
    
    enum Text {
        static let versionInformationButtonUpdateTitle = "업데이트"
        static let versionInformationButtonLatestTitle = "최신버전"
    }
}
