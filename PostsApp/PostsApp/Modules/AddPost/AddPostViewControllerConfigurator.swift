import Foundation

enum AddPostViewControllerConfigurator {
    static func configure(coordinator: AppCoordinator,
                          configurator: CoreDataConfiguratorProtocol) -> AddPostViewController {
        let localRepository = AddPostInjectionFactory.createPostsLocalRepository(configurator: configurator)
        let viewModel = AddPostViewModel(localPostsRepository: localRepository,
                                         coordinator: coordinator)
        
        let viewController = AddPostViewController(viewModel: viewModel)
        
        return viewController
    }
}
