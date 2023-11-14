import Foundation
import CoreData

@objc(PostManagedObject)
public class PostManagedObject: NSManagedObject {
    @NSManaged var title: String
    @NSManaged var body: String
}
