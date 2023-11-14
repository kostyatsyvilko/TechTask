import Foundation
import CoreData

protocol CoreDataConfigurable {
    var persistentContainer: NSPersistentContainer { get }
    var managedObjectContext: NSManagedObjectContext { get }
}
