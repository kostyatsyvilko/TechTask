import Foundation

enum CoreDataConfiguratorFactory {
    static func create() -> CoreDataConfigurator {
        let dbModel = DBConstants.coreDataModelName
        return SqlCoreDataConfigurator(dataModelName: dbModel)
    }
}
