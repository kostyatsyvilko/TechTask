import Foundation
@testable import PostsApp

final class CoreDataPostManagerMock: CoreDataPostManagerProtocol {
    
    private var posts: [PostManagedObject] = []
    private var configurator: CoreDataConfigurable
    
    init(configurator: CoreDataConfigurable = CoreDataConfigurationMock()) {
        self.configurator = configurator
    }
    
    func save(post: PostsApp.Post) throws {
        let object = createManagedObject(from: post)
        posts.append(object)
    }
    
    func save(posts: [PostsApp.Post]) throws {
        let objects = posts.map { createManagedObject(from: $0) }
        self.posts += objects
    }
    
    func delete(for title: String) throws {
        posts.removeAll { $0.title == title }
    }
    
    func exists(with title: String) throws -> Bool {
        return posts.contains { $0.title == title }
    }
    
    func fetch(predicate: NSPredicate?) throws -> [PostsApp.PostManagedObject] {
        return posts
    }
    
    private func createManagedObject(from post: Post) -> PostManagedObject {
        let object = PostManagedObject(context: configurator.managedObjectContext)
        object.title = post.title
        object.body = post.body
        
        return object
    }
    
}
