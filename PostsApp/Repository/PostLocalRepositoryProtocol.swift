import Foundation

protocol PostLocalRepositoryProtocol {
    func loadPosts() -> PostsResultType
    func exists(with title: String) -> Bool
    func saveNotExists(posts: [Post])
    func save(post: Post) throws
    func delete(post: Post) throws
}
