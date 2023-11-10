import Foundation

protocol DatabaseManager {
    func save(object: Storable) throws
    func update(object: Storable) throws
    func delete(object: Storable) throws
    func exists<T: Storable>(_ model: T.Type,
                             predicate: NSPredicate?) throws -> Bool
    func fetch<T: Storable>(_ model: T.Type,
                            predicate: NSPredicate?) throws -> [T]
}

protocol Storable {}
