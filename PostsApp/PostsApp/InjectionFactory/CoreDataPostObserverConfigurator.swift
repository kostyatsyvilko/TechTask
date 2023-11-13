import Foundation
import CoreData

enum CoreDataPostObserverConfigurator {
    static func configure(configurator: CoreDataConfigurable) -> CoreDataFetchedResultsObserver<PostManagedObject> {
        let fetchRequest = NSFetchRequest<PostManagedObject>(entityName: "PostManagedObject")
        
        let sortDescription = NSSortDescriptor(key: "title",
                                               ascending: true,
                                               selector: #selector(NSString.caseInsensitiveCompare))
        fetchRequest.sortDescriptors = [sortDescription]
        
        let observer = CoreDataFetchedResultsObserver<PostManagedObject>(fetchRequest: fetchRequest,
                                                                         managedObjectContext: configurator.managedObjectContext)
        return observer
    }
}
