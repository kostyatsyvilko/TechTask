import Foundation

protocol PostListViewModelProtocol {
    var onReceivePosts: (@MainActor (_ posts: [Post]) -> Void)? { get set }
    var onPostChange: ((ObserverChangeResult<[Post]>) -> Void)? { get set }
    var onReceiveError: ((Error) -> Void)? { get set }
    
    func startObserving()
    
    func loadRemotePosts() async
    func loadLocalPosts() async
    func delete(post: Post)
    func save(post: Post)
    
    func goToAddPost()
}

final class PostListViewModel: PostListViewModelProtocol {
    
    private let postsRepositoryManager: PostsRepositoryManagerProtocol
    private var postDatabaseObserver: PostDatabaseObserverProtocol
    private let coordinator: AppCoordinator
    
    var onReceivePosts: (@MainActor (_ posts: [Post]) -> Void)?
    var onPostChange: ((ObserverChangeResult<[Post]>) -> Void)?
    var onReceiveError: ((Error) -> Void)?
    
    init(postsRepositoryManager: PostsRepositoryManagerProtocol,
         postDatabaseObserver: PostDatabaseObserverProtocol,
         coordinator: AppCoordinator) {
        self.postsRepositoryManager = postsRepositoryManager
        self.postDatabaseObserver = postDatabaseObserver
        self.coordinator = coordinator
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
            onReceiveError?(error)
        }
    }
    
    func loadLocalPosts() async {
        let result = postsRepositoryManager.loadLocalPosts()
        switch result {
        case .success(let posts):
            await onReceivePosts?(posts)
        case .failure(let error):
            onReceiveError?(error)
        }
    }
    
    func save(post: Post) {
        do {
            try postsRepositoryManager.saveLocal(post: post)
        } catch let error {
            onReceiveError?(error)
        }
    }
    
    func delete(post: Post) {
        do {
            try postsRepositoryManager.deleteLocal(post: post)
        } catch let error {
            onReceiveError?(error)
        }
    }
}

extension PostListViewModel {
    func goToAddPost() {
        coordinator.goToAddPost()
    }
}
