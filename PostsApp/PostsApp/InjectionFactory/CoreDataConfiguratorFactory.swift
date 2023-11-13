import Foundation

enum CoreDataConfiguratorFactory {
    static func create() -> CoreDataConfigurable {
        let dbModel = DBConstants.coreDataModelName
        return SqlCoreDataConfigurator(dataModelName: dbModel)
    }
}
