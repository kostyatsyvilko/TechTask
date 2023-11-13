import Foundation

final class PostsLocalRepository: PostsLocalRepositoryProtocol {
    private let coreDataManager: CoreDataPostManagerProtocol
    
    init(coreDataManager: CoreDataPostManagerProtocol) {
        self.coreDataManager = coreDataManager
    }
    
    func loadPosts() -> PostsResultType {
        do {
            let result = try coreDataManager.fetch(predicate: nil)
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
        let value = try? coreDataManager.exists(with: title)
        return value ?? false
    }
    
    func save(post: Post) throws {
        try coreDataManager.save(post: post)
    }
    
    func delete(post: Post) throws {
        try coreDataManager.delete(for: post.title)
    }
    
    private func saveAll(posts: [Post]) {
        try? coreDataManager.save(posts: posts)
    }
}
