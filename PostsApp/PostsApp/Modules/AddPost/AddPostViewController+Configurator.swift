import Foundation

extension AddPostViewController {
    static func configure(coordinator: AppCoordinator,
                          coreDataConfigurator: CoreDataConfiguratorProtocol) -> AddPostViewController {
        let factory = PostInjectionFactory(coreDataConfigurator: coreDataConfigurator)
        let localRepository = factory.createPostsLocalRepository()
        let viewModel = AddPostViewModel(localPostsRepository: localRepository,
                                         coordinator: coordinator)
        
        let viewController = AddPostViewController()
        viewController.viewModel = viewModel
        
        return viewController
    }
}
