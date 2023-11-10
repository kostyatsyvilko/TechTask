import Foundation

protocol PostsLocalRepositoryProtocol {
    func loadPosts() -> PostsResultType
    func exists(with title: String) -> Bool
    func saveNotExists(posts: [Post])
    func save(post: Post)
    func delete(post: Post)
}
