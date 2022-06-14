import UIKit

final class YesOrNoCardView: UIImageView, CardViewProtocol {
    private let questionLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.font = Design.questionLabelFont
        label.numberOfLines = 0
        label.lineBreakStrategy = .hangulWordPriority
        label.textColor = .white  // TODO: 텍스트 색상 고려
        return label
    }()
    
    convenience init(image: UIImage?, title: String) {
        self.init(image: image)
        configureUI()
        configureLabel(with: title)
    }
    
    func configureUI() {
        translatesAutoresizingMaskIntoConstraints = true
        layer.cornerRadius = 8
        clipsToBounds = true
        contentMode = .scaleAspectFill
        
        addSubview(questionLabel)
        
        NSLayoutConstraint.activate([
            questionLabel.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            questionLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
    
    private func configureLabel(with title: String) {
        questionLabel.text = title
    }
}

// MARK: - NameSpaces
extension YesOrNoCardView {
    private enum Design {
        static let questionLabelFont: UIFont = .preferredFont(forTextStyle: .largeTitle)
    }
}
