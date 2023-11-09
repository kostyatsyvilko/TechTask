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
    
    func saveIfNotExists(post: Post) {
        do {
            let predicate = NSPredicate(format: "title == %@", post.title)
            if try !databaseManager.exists(PostManagedObject.self, predicate: predicate) {
                save(post: post)
            }
        } catch {
            
        }
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
        let postObject = PostManagedObject(context: databaseManager.mainContext)
        postObject.title = post.title
        postObject.body = post.body
        do {
            try databaseManager.delete(object: postObject)
        } catch {}
    }
}
