import Foundation

enum AddPostInjectionFactory {
    static func createPostsLocalRepository(configurator: CoreDataConfigurable) -> PostLocalRepositoryProtocol {
        let dbManager = CoreDataPostManager(coreDataConfigurator: configurator)
        return PostLocalRepository(coreDataManager: dbManager)
    }
}
