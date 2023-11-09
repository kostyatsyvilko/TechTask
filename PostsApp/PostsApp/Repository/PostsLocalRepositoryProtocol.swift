import Foundation

protocol PostsLocalRepositoryProtocol {
    func loadPosts() -> PostsResultType
    func saveIfNotExists(post: Post)
    func save(post: Post)
    func delete(post: Post)
}
