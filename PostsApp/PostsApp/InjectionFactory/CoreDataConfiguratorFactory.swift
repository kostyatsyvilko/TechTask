import Foundation

struct CoreDataConfiguratorFactory {
    static func create() -> CoreDataConfigurator {
        let dbModel = DBConstants.coreDataModelName
        return CoreDataConfigurator(dataModelName: dbModel)
    }
}
