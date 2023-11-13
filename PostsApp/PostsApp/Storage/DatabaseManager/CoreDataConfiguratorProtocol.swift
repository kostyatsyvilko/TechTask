import Foundation
import CoreData

protocol CoreDataConfiguratorProtocol {
    var persistentContainer: NSPersistentContainer { get }
    var managedObject: NSManagedObjectContext { get }
}
