import UIKit

extension UITableView {
    func register<T: UITableViewCell>(cellType: T.Type) {
        register(cellType, forCellReuseIdentifier: String(describing: cellType))
    }
    
    func dequeueReusableCell<T: UITableViewCell>(of cellType: T.Type, for indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(withIdentifier: String(describing: cellType), for: indexPath) as? T else {
            return T()
        }
        return cell
    }
}
