import Foundation

extension PostListViewController {
    static func configure(coordinator: AppCoordinator,
                          coreDataConfigurator: CoreDataConfiguratorProtocol) -> PostListViewController {
        let factory = PostInjectionFactory(coreDataConfigurator: coreDataConfigurator)
        let observer = factory.createPostDatabaseObserver()
        let repositoryManager = factory.createPostsRepositoryManager()
        
        let viewModel = PostListViewModel(postsRepositoryManager: repositoryManager,
                                          postDatabaseObserver: observer,
                                          coordinator: coordinator)
        let viewController = PostListViewController(viewModel: viewModel)
        
        return viewController
    }
}
