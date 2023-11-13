import Foundation
import CoreData

struct CoreDataPostObserverFactory {
    static func create(coreDataConfigurator: CoreDataConfiguratorProtocol) -> CoreDataFetchedResultsObserver<PostManagedObject> {
        return CoreDataPostObserverConfigurator(coreDataConfigurator: coreDataConfigurator).configure()
    }
}
