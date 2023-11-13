import Foundation

final class PostsLocalRepository: PostsLocalRepositoryProtocol {
    private let databaseManager: CoreDataManager
    
    init(databaseManager: CoreDataManager) {
        self.databaseManager = databaseManager
    }
    
    func loadPosts() -> PostsResultType {
        do {
            let result = try databaseManager.fetch(PostManagedObject.self, predicate: nil)
            let posts = result.map { Post(from: $0) }.sorted { $0.title.caseInsensitiveCompare($1.title) == .orderedAscending }
            return .success(posts)
        } catch let error {
            return .failure(error)
        }
    }
    
    func saveNotExists(posts: [Post]) {
        let filtered = posts.filter { !exists(with: $0.title) }
        saveAll(posts: filtered)
    }
    
    func exists(with title: String) -> Bool {
        let predicate = NSPredicate(format: "title == %@", title)
        let value = try? databaseManager.exists(PostManagedObject.self, predicate: predicate)
        return value ?? false
    }
    
    func save(post: Post) throws {
        let postObject = PostManagedObject(context: databaseManager.childContext)
        postObject.title = post.title
        postObject.body = post.body
        try databaseManager.save(object: postObject)
    }
    
    func delete(post: Post) throws {
        let predicate = NSPredicate(format: "title == %@", post.title)
        let postObjects = try databaseManager.fetch(PostManagedObject.self, predicate: predicate)
        if let postObject = postObjects.first {
            try databaseManager.delete(object: postObject)
        }
     
    }
    
    private func saveAll(posts: [Post]) {
        let objects = posts.map { convertToManagedObject(post: $0) }
        if let object = objects.first {
            try? databaseManager.save(object: object)
        }
    }
    
    private func convertToManagedObject(post: Post) -> PostManagedObject {
        let postObject = PostManagedObject(context: databaseManager.mainContext)
        postObject.title = post.title
        postObject.body = post.body
        
        return postObject
    }
}
