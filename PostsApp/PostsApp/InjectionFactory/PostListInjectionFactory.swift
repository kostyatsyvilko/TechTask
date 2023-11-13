import Foundation

enum PostListInjectionFactory {
    static func createPostsRepositoryManager(configurator: CoreDataConfigurable) -> PostsRepositoryManagerProtocol {
        let dbManager = CoreDataPostManager(coreDataConfigurator: configurator)
        let localRepository = PostsLocalRepository(coreDataManager: dbManager)
        
        let apiClient = ApiClientFactory.createPostRepository()
        let remoteRepository = PostsRemoteRepository(apiClient: apiClient)
        
        return PostsRepositoryManager(localRepository: localRepository,
                                      remoteRepository: remoteRepository)
    }
    
    static func createPostDatabaseObserver(configurator: CoreDataConfigurable) -> PostDatabaseObserver {
        let observer = CoreDataPostObserverConfigurator.configure(configurator: configurator)
        return PostCoreDataObserver(databaseObserver: observer)
    }
}
