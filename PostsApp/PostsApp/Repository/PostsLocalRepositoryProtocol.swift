import Foundation

protocol PostsLocalRepositoryProtocol {
    func loadPosts() -> PostsResultType
    func saveNotExists(posts: [Post])
    func save(post: Post)
    func delete(post: Post)
}
