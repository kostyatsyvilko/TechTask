import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    let coreDataConfigurator: CoreDataConfigurator
    
    init(navigationController: UINavigationController,
         coreDataConfigurator: CoreDataConfigurator) {
        self.navigationController = navigationController
        self.coreDataConfigurator = coreDataConfigurator
    }
    
    func start() {
        let viewController = PostListViewControllerConfigurator.configure(coordinator: self,
                                                                          configurator: coreDataConfigurator)
        navigationController.pushViewController(viewController, animated: false)
    }
}

extension AppCoordinator {
    func goToAddPost() {
        let viewController = AddPostViewControllerConfigurator.configure(coordinator: self,
                                                                         configurator: coreDataConfigurator)
        navigationController.pushViewController(viewController, animated: true)
    }
}
