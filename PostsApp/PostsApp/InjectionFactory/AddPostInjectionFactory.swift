import Foundation

enum AddPostInjectionFactory {
    static func createPostsLocalRepository(configurator: CoreDataConfiguratorProtocol) -> PostsLocalRepositoryProtocol {
        let dbManager = CoreDataPostManager(coreDataConfigurator: configurator)
        return PostsLocalRepository(databaseManager: dbManager)
    }
}
