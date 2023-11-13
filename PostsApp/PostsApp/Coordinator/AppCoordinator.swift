import Foundation
import UIKit

final class AppCoordinator: Coordinator {
    var navigationController: UINavigationController
    let coreDataConfigurator: CoreDataConfigurable
    
    init(navigationController: UINavigationController,
         coreDataConfigurator: CoreDataConfigurable) {
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
