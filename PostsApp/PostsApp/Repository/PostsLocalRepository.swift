import Foundation

final class PostsLocalRepository: PostsLocalRepositoryProtocol {
    private var databaseManager: CoreDataManager
    
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
    
    func save(post: Post) {
        let postObject = PostManagedObject(context: databaseManager.childContext)
        postObject.title = post.title
        postObject.body = post.body
        do {
            try databaseManager.save(object: postObject)
        } catch {}
    }
    
    func delete(post: Post) {
        let predicate = NSPredicate(format: "title == %@", post.title)
        do {
            let postObjects = try databaseManager.fetch(PostManagedObject.self, predicate: predicate)
            if let postObject = postObjects.first {
                try databaseManager.delete(object: postObject)
            }
        } catch {}
    }
    
    private func saveAll(posts: [Post]) {
        let objects = posts.map { convertToManagedObject(post: $0) }
        
        do {
            if let object = objects.first {
                try databaseManager.save(object: object)
            }
        } catch {}
    }
    
    private func convertToManagedObject(post: Post) -> PostManagedObject {
        let postObject = PostManagedObject(context: databaseManager.mainContext)
        postObject.title = post.title
        postObject.body = post.body
        
        return postObject
    }
}
