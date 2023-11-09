import Foundation

protocol PostListViewModelProtocol {
    var onReceivePosts: (@MainActor (_ posts: [Post]) -> Void)? { get set }
    
    func loadRemotePosts() async
    func loadLocalPosts() async
    func deletePost(post: Post)
}

final class PostListViewModel: PostListViewModelProtocol {
    
    private let postsRepositoryManager: PostsRepositoryManagerProtocol
    
    var onReceivePosts: (@MainActor (_ posts: [Post]) -> Void)?
    
    init(postsRepositoryManager: PostsRepositoryManagerProtocol) {
        self.postsRepositoryManager = postsRepositoryManager
    }
    
    func loadRemotePosts() async {
        let result = await postsRepositoryManager.loadRemotePosts()
        switch result {
        case .success(_):
            break
        case .failure(let error):
            debugPrint(error)
        }
    }
    
    func loadLocalPosts() async {
        let result = postsRepositoryManager.loadLocalPosts()
        switch result {
        case .success(let posts):
            await onReceivePosts?(posts)
        case .failure(let error):
            debugPrint(error)
        }
    }
    
    func deletePost(post: Post) {
        postsRepositoryManager.deleteLocal(post: post)
    }
}
