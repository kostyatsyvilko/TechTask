import Foundation
@testable import PostsApp

final class PostLocalRepositoryMock: PostLocalRepositoryProtocol {
    
    var posts: [Post] = []
    
    func loadPosts() -> PostsApp.PostsResultType {
        return .success(posts)
    }
    
    func exists(with title: String) -> Bool {
        return posts.contains { $0.title == title }
    }
    
    func saveNotExists(posts: [PostsApp.Post]) {
        let objects = posts.filter { !exists(with: $0.title) }
        
        objects.forEach { try? save(post: $0) }
    }
    
    func save(post: PostsApp.Post) throws {
        posts.append(post)
    }
    
    func delete(post: PostsApp.Post) throws {
        posts.removeAll { $0.title == post.title }
    }
    
    
}
