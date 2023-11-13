import Foundation

enum AddPostInjectionFactory {
    static func createPostsLocalRepository(configurator: CoreDataConfigurable) -> PostsLocalRepositoryProtocol {
        let dbManager = CoreDataPostManager(coreDataConfigurator: configurator)
        return PostsLocalRepository(coreDataManager: dbManager)
    }
}
