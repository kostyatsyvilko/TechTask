import Foundation
import CoreData

final class CoreDataPostObserverConfigurator {
    private var coreDataConfigurator: CoreDataConfigurator
    
    init(coreDataConfigurator: CoreDataConfigurator) {
        self.coreDataConfigurator = coreDataConfigurator
    }
    
    func configure() -> CoreDataFetchedResultsObserver<PostManagedObject> {
        let fetchRequest = NSFetchRequest<PostManagedObject>(entityName: "PostManagedObject")
        
        let sortDescription = NSSortDescriptor(key: "title",
                                               ascending: true,
                                               selector: #selector(NSString.caseInsensitiveCompare))
        fetchRequest.sortDescriptors = [sortDescription]
        
        let observer = CoreDataFetchedResultsObserver<PostManagedObject>(fetchRequest: fetchRequest,
                                                                         managedObjectContext: coreDataConfigurator.managedObject)
        return observer
    }
}
