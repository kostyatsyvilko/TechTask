import Foundation

extension PostListViewController {
    static func configure(coordinator: AppCoordinator,
                          coreDataConfigurator: CoreDataConfigurator) -> PostListViewController {
        let factory = PostInjectionFactory(coreDataConfigurator: coreDataConfigurator)
        let observer = factory.createPostDatabaseObserver()
        let repositoryManager = factory.createPostsRepositoryManager()
        
        let viewModel = PostListViewModel(postsRepositoryManager: repositoryManager,
                                          postDatabaseObserver: observer,
                                          coordinator: coordinator)
        let viewController = PostListViewController()
        viewController.viewModel = viewModel
        
        return viewController
    }
}
