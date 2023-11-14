import Foundation

enum PostListViewControllerConfigurator {
    static func configure(coordinator: AppCoordinator,
                          configurator: CoreDataConfigurable) -> PostListViewController {
        let observer = PostListInjectionFactory.createPostDatabaseObserver(configurator: configurator)
        let repositoryManager = PostListInjectionFactory.createPostsRepositoryManager(configurator: configurator)
        
        let viewModel = PostListViewModel(postsRepositoryManager: repositoryManager,
                                          postDatabaseObserver: observer,
                                          coordinator: coordinator)
        let viewController = PostListViewController(viewModel: viewModel)
        
        return viewController
    }
}
