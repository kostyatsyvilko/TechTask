import Foundation

struct CoreDataPostManagerFactory {
    static func create(coreDataConfigurator: CoreDataConfiguratorProtocol) -> CoreDataPostManagerProtocol {
        return CoreDataPostManager(coreDataConfigurator: coreDataConfigurator)
    }
}
