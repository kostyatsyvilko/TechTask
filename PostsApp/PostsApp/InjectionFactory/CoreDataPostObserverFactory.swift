import Foundation
import CoreData

struct CoreDataPostObserverFactory {
    static func create(coreDataConfigurator: CoreDataConfigurator) -> CoreDataFetchedResultsObserver<PostManagedObject> {
        return CoreDataPostObserverConfigurator(coreDataConfigurator: coreDataConfigurator).configure()
    }
}
