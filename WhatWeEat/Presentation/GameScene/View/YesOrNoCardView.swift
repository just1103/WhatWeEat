import UIKit

final class YesOrNoCardView: UIView, CardViewProtocol {
    // MARK: - Properties
    private let filterView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Design.filterViewBackgroundColor
        view.layer.cornerRadius = Design.cornerRadius
        view.clipsToBounds = true
        return view
    }()
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = Design.cornerRadius
        imageView.clipsToBounds = true
        return imageView
    }()
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Design.questionLabelFont
        label.numberOfLines = .zero
        label.lineBreakStrategy = .hangulWordPriority
        label.textColor = Design.questionLabelTextColor
        return label
    }()
    
    // MARK: - Initializers
    convenience init(image: UIImage?, title: String) {
        self.init(frame: .zero)
        configureUI()
        configureImageView(with: image)
        configureLabel(with: title)
    }
    
    // MARK: - Methods
    func configureUI() {
        self.backgroundColor = Design.backgroundColor
        
        addSubview(imageView)
        addSubview(filterView)
        addSubview(questionLabel)
        
        NSLayoutConstraint.activate([
            filterView.topAnchor.constraint(equalTo: self.topAnchor),
            filterView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            filterView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            filterView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            imageView.topAnchor.constraint(equalTo: self.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            questionLabel.leadingAnchor.constraint(
                equalTo: self.leadingAnchor,
                constant: Constraint.questionLabelLeadingAnchorConstant
            ),
            questionLabel.trailingAnchor.constraint(
                equalTo: self.trailingAnchor,
                constant: Constraint.questionLabelTrailingAnchorConstant
            ),
            questionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    func configureImageView(with image: UIImage?) {
        imageView.image = image
    }
    
    private func configureLabel(with title: String) {
        questionLabel.text = title
    }

}

// MARK: - NameSpaces
extension YesOrNoCardView {
    private enum Design {
        static let questionLabelFont: UIFont = .pretendardDefaultSize(family: .bold)
        static let filterViewBackgroundColor: UIColor = .black.withAlphaComponent(0.5)
        static let cornerRadius: CGFloat = 30
        static let questionLabelTextColor: UIColor = .white
        static let backgroundColor: UIColor = .clear
    }
    
    private enum Constraint {
        static let questionLabelLeadingAnchorConstant: CGFloat = 10
        static let questionLabelTrailingAnchorConstant: CGFloat = -10
    }
}
