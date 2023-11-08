import Foundation
import UIKit
import CoreData

final class CoreDataManager {
    private let coreDataConfigurator: CoreDataConfigurator
    
    var mainContext: NSManagedObjectContext {
        coreDataConfigurator.managedObject
    }
    
    private(set) lazy var childContext: NSManagedObjectContext = {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = mainContext
        return context
    }()
    
    init(coreDataConfigurator: CoreDataConfigurator) {
        self.coreDataConfigurator = coreDataConfigurator
    }
}

extension CoreDataManager: DatabaseManager {
    func save(object: Storable) throws {
        do {
            try childContext.save()
            try mainContext.save()
        } catch {
            throw DatabaseError.save
        }
    }
    
    func update(object: Storable) throws {
        do {
            try childContext.save()
            try mainContext.save()
        } catch {
            throw DatabaseError.save
        }
    }
    
    func delete(object: Storable) throws {
        guard let model = object as? NSManagedObject else {
            throw DatabaseError.incorrectModel
        }
        do {
            mainContext.delete(model)
            try mainContext.save()
        } catch {
            throw DatabaseError.delete
        }
    }
    
    func fetch<T>(_ model: T.Type, predicate: NSPredicate?) throws -> [T] where T : Storable {
        guard let object = model as? NSManagedObject.Type else {
            throw DatabaseError.incorrectModel
        }
        let fetchRequest = object.fetchRequest()
        fetchRequest.predicate = predicate

        do {
            let fetchResult = try mainContext.fetch(fetchRequest)
            return fetchResult.compactMap { $0 as? T }
        } catch {
            throw DatabaseError.fetch
        }
    }
}

extension NSManagedObject: Storable {}
