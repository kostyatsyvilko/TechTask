import Foundation
import CoreData

protocol CoreDataConfigurator {
    var persistentContainer: NSPersistentContainer { get }
    var managedObject: NSManagedObjectContext { get }
}
