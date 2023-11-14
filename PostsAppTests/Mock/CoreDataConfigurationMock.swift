@testable import PostsApp
import CoreData

final class CoreDataConfigurationMock: CoreDataConfigurable {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: DBConstants.coreDataModelName)
        container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        container.loadPersistentStores { storeDescription, error in
            if let error {
                fatalError("Can not load persistent stores")
            }
        }
        return container
    }()
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
}
