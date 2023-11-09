import Foundation

protocol PostListViewModelProtocol {
    var onReceivePosts: (@MainActor (_ posts: [Post]) -> Void)? { get set }
    var onPostChange: ((ObserverChangeResult<[Post]>) -> Void)? { get set }
    
    func startObserving()
    
    func loadRemotePosts() async
    func loadLocalPosts() async
    func deletePost(post: Post)
    func savePost(post: Post)
}

final class PostListViewModel: PostListViewModelProtocol {
    
    private let postsRepositoryManager: PostsRepositoryManagerProtocol
    private var postDatabaseObserver: PostDatabaseObserverProtocol
    
    var onReceivePosts: (@MainActor (_ posts: [Post]) -> Void)?
    var onPostChange: ((ObserverChangeResult<[Post]>) -> Void)?
    
    init(postsRepositoryManager: PostsRepositoryManagerProtocol,
         postDatabaseObserver: PostDatabaseObserverProtocol) {
        self.postsRepositoryManager = postsRepositoryManager
        self.postDatabaseObserver = postDatabaseObserver
    }
    
    func startObserving() {
        postDatabaseObserver.onChange = onPostChange
        postDatabaseObserver.startObserving()
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
    
    func savePost(post: Post) {
        postsRepositoryManager.saveLocal(post: post)
    }
    
    func deletePost(post: Post) {
        postsRepositoryManager.deleteLocal(post: post)
    }
}
