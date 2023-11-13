import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    let coreDataConfigurator: CoreDataConfiguratorProtocol
    
    init(navigationController: UINavigationController,
         coreDataConfigurator: CoreDataConfiguratorProtocol) {
        self.navigationController = navigationController
        self.coreDataConfigurator = coreDataConfigurator
    }
    
    func start() {
        let viewController = PostListViewController.configure(coordinator: self,
                                                              coreDataConfigurator: coreDataConfigurator)
        navigationController.pushViewController(viewController, animated: false)
    }
}

extension AppCoordinator {
    func goToAddPost() {
        let viewController = AddPostViewController.configure(coordinator: self,
                                                             coreDataConfigurator: coreDataConfigurator)
        navigationController.pushViewController(viewController, animated: true)
    }
}
