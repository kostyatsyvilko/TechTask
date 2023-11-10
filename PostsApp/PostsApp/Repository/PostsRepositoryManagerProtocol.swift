import Foundation

protocol PostsRepositoryManagerProtocol {
    func loadRemotePosts() async -> PostsResultType
    func loadLocalPosts() -> PostsResultType
    
    func saveLocal(post: Post)
    func deleteLocal(post: Post)
}
