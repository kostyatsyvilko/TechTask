import Foundation
import CoreData

final class SqlCoreDataConfigurator: CoreDataConfigurable {
    private let dataModelName: String
    
    private(set) lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: dataModelName)
        container.loadPersistentStores { storeDescription, error in
            if let error {
                fatalError("Can not load persistent stores")
            }
        }
        
        return container
    }()
    
    private(set) lazy var managedObjectContext: NSManagedObjectContext = {
        return persistentContainer.viewContext
    }()
    
    init(dataModelName: String) {
        self.dataModelName = dataModelName
    }
}
