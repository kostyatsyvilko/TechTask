import UIKit

class BaseViewController: UIViewController {
    func showErrorAlert(title: String, message: String, confirmButtonText: String = "Ok") {
        let actionSheet = UIAlertController(
            title: title,
            message: message,
            preferredStyle: .alert)
        
        let okAction = UIAlertAction(title: confirmButtonText, style: .default)
        
        actionSheet.addAction(okAction)
        
        present(actionSheet, animated: true)
    }
}
