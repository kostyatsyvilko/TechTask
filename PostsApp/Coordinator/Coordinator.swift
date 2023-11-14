import Foundation
import UIKit

protocol Coordinator {
    var navigationController: UINavigationController { get set }
    
    func start()
}

extension Coordinator {
    func goBack() {
        navigationController.popViewController(animated: true)
    }
}
