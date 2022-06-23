import UIKit

extension UIView {
    enum ShadowDirection {
        case top, left, right, bottom
    }

    func applyShadow(
        direction: ShadowDirection,
        color: UIColor = .darkGray,
        opacity: Float = 0.9,
        radius: CGFloat = 5.0
    ) {
        switch direction {
        case .top:
            applyShadow(offset: CGSize(width: 0, height: -5), color: color, opacity: opacity, radius: radius)
        case .left:
            applyShadow(offset: CGSize(width: -5, height: 0), color: color, opacity: opacity, radius: radius)
        case .right:
            applyShadow(offset: CGSize(width: 5, height: 0), color: color, opacity: opacity, radius: radius)
        case .bottom:
            applyShadow(offset: CGSize(width: 0, height: 5), color: color, opacity: opacity, radius: radius)
        }
    }

    func applyShadow(
        offset: CGSize,
        color: UIColor = .darkGray,
        opacity: Float = 0.9,
        radius: CGFloat = 5.0
    ) {
        self.layer.masksToBounds = false
        self.layer.shadowOffset = offset
        self.layer.shadowColor = color.cgColor
        self.layer.shadowOpacity = opacity
        self.layer.shadowRadius = radius
    }
}
