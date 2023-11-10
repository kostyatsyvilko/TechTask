import Foundation

struct CoreDataManagerFactory {
    static func create(coreDataConfigurator: CoreDataConfigurator) -> CoreDataManager {
        return CoreDataManager(coreDataConfigurator: coreDataConfigurator)
    }
}
