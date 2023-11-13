import Foundation

enum AddPostInjectionFactory {
    static func createPostsLocalRepository(configurator: CoreDataConfigurator) -> PostsLocalRepositoryProtocol {
        let dbManager = CoreDataPostManager(coreDataConfigurator: configurator)
        return PostsLocalRepository(databaseManager: dbManager)
    }
}
