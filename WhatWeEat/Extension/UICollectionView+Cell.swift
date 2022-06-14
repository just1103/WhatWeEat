import UIKit

extension UICollectionView {
    func register<T: UICollectionViewCell>(cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: String(describing: cellType))
    }
}
