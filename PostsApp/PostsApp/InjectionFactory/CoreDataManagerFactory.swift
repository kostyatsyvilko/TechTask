import Foundation

struct CoreDataManagerFactory {
    static func create(coreDataConfigurator: CoreDataConfiguratorProtocol) -> CoreDataManager {
        return CoreDataManager(coreDataConfigurator: coreDataConfigurator)
    }
}
