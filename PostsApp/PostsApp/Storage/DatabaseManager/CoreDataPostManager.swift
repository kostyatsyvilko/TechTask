import Foundation
import CoreData

protocol CoreDataPostManagerProtocol {
    func save(post: Post) throws
    func save(posts: [Post]) throws
    func delete(for title: String) throws
    func exists(with title: String) throws -> Bool
    func fetch(predicate: NSPredicate?) throws -> [PostManagedObject]
}

final class CoreDataPostManager: CoreDataPostManagerProtocol {
    private let coreDataConfigurator: CoreDataConfigurable
    
    private var mainContext: NSManagedObjectContext {
        coreDataConfigurator.managedObject
    }
    
    private lazy var childContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        return context
    }()
    
    init(coreDataConfigurator: CoreDataConfigurable) {
        self.coreDataConfigurator = coreDataConfigurator
    }
    
    func save(post: Post) throws {
        createManagedObject(from: post)
        
        do {
            try childContext.save()
            try mainContext.save()
        } catch {
            throw DatabaseError.save
        }
    }
    
    func save(posts: [Post]) throws {
        let _ = posts.map { createManagedObject(from: $0) }
        
        do {
            try childContext.save()
            try mainContext.save()
        } catch {
            throw DatabaseError.save
        }
    }
    
    func delete(for title: String) throws {
        let predicate = NSPredicate(format: "title == %@", title)
        let objects = try fetch(predicate: predicate)
        
        guard let object = objects.first else {
            return
        }
        mainContext.delete(object)
        
        do {
            try mainContext.save()
        } catch {
            throw DatabaseError.delete
        }
    }
    
    func exists(with title: String) throws -> Bool {
        let predicate = NSPredicate(format: "title == %@", title)
        do {
            let objects = try fetch(predicate: predicate)
            return objects.count > 0
        } catch {
            throw DatabaseError.exists
        }
    }
    
    func fetch(predicate: NSPredicate?) throws -> [PostManagedObject] {
        let fetchRequest = NSFetchRequest<PostManagedObject>(entityName: String(describing: PostManagedObject.self))
        fetchRequest.predicate = predicate
        
        do {
            let fetchResult = try mainContext.fetch(fetchRequest)
            return fetchResult
        } catch {
            throw DatabaseError.fetch
        }
    }
}

extension CoreDataPostManager {
    private func createManagedObject(from post: Post) {
        let object = PostManagedObject(context: childContext)
        object.title = post.title
        object.body = post.body
    }
}
