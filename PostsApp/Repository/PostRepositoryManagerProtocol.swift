import Foundation

protocol PostRepositoryManagerProtocol {
    func loadRemotePosts() async -> PostsResultType
    func loadLocalPosts() -> PostsResultType
    
    func saveLocal(post: Post) throws
    func deleteLocal(post: Post) throws
}
