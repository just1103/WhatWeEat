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
            applyShadow(offset: CGSize(width: 0, height: -4), color: color, opacity: opacity, radius: radius)
        case .left:
            applyShadow(offset: CGSize(width: -4, height: 0), color: color, opacity: opacity, radius: radius)
        case .right:
            applyShadow(offset: CGSize(width: 4, height: 0), color: color, opacity: opacity, radius: radius)
        case .bottom:
            applyShadow(offset: CGSize(width: 0, height: 4), color: color, opacity: opacity, radius: radius)
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
    
    func applyGradation(width: CGFloat, height: CGFloat, radius: CGFloat = 0) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(
            origin: self.bounds.origin,
            size: CGSize(width: width, height: height)
        )
        gradientLayer.locations = [0.15]
        gradientLayer.colors = [UIColor.black.cgColor, UIColor.clear.cgColor]
        gradientLayer.cornerRadius = radius
        self.layer.addSublayer(gradientLayer)
    }
}
