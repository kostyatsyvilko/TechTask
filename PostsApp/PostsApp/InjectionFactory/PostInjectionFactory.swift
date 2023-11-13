import Foundation

final class PostInjectionFactory {
    
    let coreDataConfigurator: CoreDataConfiguratorProtocol
    
    init(coreDataConfigurator: CoreDataConfiguratorProtocol) {
        self.coreDataConfigurator = coreDataConfigurator
    }
    
    func createPostsRepositoryManager() -> PostsRepositoryManagerProtocol {
        let localRepository = createPostsLocalRepository()
        let remoteRepository = createPostsRemoteRepository()
        
        return PostsRepositoryManager(localRepository: localRepository,
                                      remoteRepository: remoteRepository)
    }
    
    func createPostsLocalRepository() -> PostsLocalRepositoryProtocol {
        let dbManager = CoreDataPostManagerFactory.create(coreDataConfigurator: coreDataConfigurator)
        return PostsLocalRepository(databaseManager: dbManager)
    }
    
    func createPostsRemoteRepository() -> PostsRemoteRepositoryProtocol {
        let apiClient = JsonPlaceholderApiClientFactory.create()
        return PostsRemoteRepository(apiClient: apiClient)
    }
    
    func createPostDatabaseObserver() -> PostDatabaseObserverProtocol {
        let observer = CoreDataPostObserverFactory.create(coreDataConfigurator: coreDataConfigurator)
        return PostDatabaseObserver(databaseObserver: observer)
    }
}
