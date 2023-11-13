import Foundation

enum PostListInjectionFactory {
    static func createPostsRepositoryManager(configurator: CoreDataConfiguratorProtocol) -> PostsRepositoryManagerProtocol {
        let dbManager = CoreDataPostManager(coreDataConfigurator: configurator)
        let localRepository = PostsLocalRepository(databaseManager: dbManager)
        
        let apiClient = ApiClientFactory.createPostRepository()
        let remoteRepository = PostsRemoteRepository(apiClient: apiClient)
        
        return PostsRepositoryManager(localRepository: localRepository,
                                      remoteRepository: remoteRepository)
    }
    
    static func createPostDatabaseObserver(configurator: CoreDataConfiguratorProtocol) -> PostDatabaseObserverProtocol {
        let observer = CoreDataPostObserverConfigurator(coreDataConfigurator: configurator).configure()
        return PostDatabaseObserver(databaseObserver: observer)
    }
}
