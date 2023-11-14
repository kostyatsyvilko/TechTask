import Foundation

enum PostListInjectionFactory {
    static func createPostsRepositoryManager(configurator: CoreDataConfigurable) -> PostRepositoryManagerProtocol {
        let dbManager = CoreDataPostManager(coreDataConfigurator: configurator)
        let localRepository = PostLocalRepository(coreDataManager: dbManager)
        
        let apiClient = ApiClientFactory.createPostRepository()
        let remoteRepository = PostRemoteRepository(apiClient: apiClient)
        
        return PostRepositoryManager(localRepository: localRepository,
                                      remoteRepository: remoteRepository)
    }
    
    static func createPostDatabaseObserver(configurator: CoreDataConfigurable) -> PostDatabaseObserver {
        let observer = CoreDataPostObserverConfigurator.configure(configurator: configurator)
        return PostCoreDataObserver(databaseObserver: observer)
    }
}
