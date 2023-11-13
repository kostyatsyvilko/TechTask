import Foundation
import CoreData

final class CoreDataFetchedResultsObserver<T: NSManagedObject>: NSObject, NSFetchedResultsControllerDelegate {
    var onChange: ((ObserverChangeResult<[T]>) -> Void)?
    
    private let resultsController: NSFetchedResultsController<T>
    
    init(fetchRequest: NSFetchRequest<T>,
         managedObjectContext: NSManagedObjectContext,
         sectionNameKeyPath: String? = nil,
         cacheName: String? = nil) {
        self.resultsController = NSFetchedResultsController(fetchRequest: fetchRequest,
                                                            managedObjectContext: managedObjectContext,
                                                            sectionNameKeyPath: sectionNameKeyPath,
                                                            cacheName: cacheName)
        super.init()
        resultsController.delegate = self
    }
    
    func startObserving() throws {
        try resultsController.performFetch()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        guard let sections = controller.sections else {
            return
        }

        sections.forEach { info in
            guard let objects = info.objects?.compactMap({ $0 as? T }) else { return }
            let type = ObserverChangeType(rawValue: info.name) ?? .unknown
            let changeResult = ObserverChangeResult(type: type, value: objects)
            onChange?(changeResult)
        }
    }
}
