import UIKit

struct AlertFactory {
    func createAlert(
        style: UIAlertController.Style = .alert,
        title: String? = nil,
        message: String? = nil,
        actions: UIAlertAction...
    ) -> UIAlertController {
        let alert = UIAlertController(title: title, message: message, preferredStyle: style)
        actions.forEach { action in
            alert.addAction(action)
        }
        
        return alert
    }
}
