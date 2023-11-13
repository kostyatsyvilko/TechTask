import Foundation

enum CoreDataConfiguratorFactory {
    static func create() -> CoreDataConfiguratorProtocol {
        let dbModel = DBConstants.coreDataModelName
        return CoreDataConfigurator(dataModelName: dbModel)
    }
}
