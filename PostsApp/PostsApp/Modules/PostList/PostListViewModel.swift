import Foundation

protocol PostListViewModelProtocol {
    var onReceivePosts: ((_ posts: [Post]) -> Void)? { get set }
    var onPostChange: ((ObserverChangeResult<[Post]>) -> Void)? { get set }
    var onReceiveError: ((Error) -> Void)? { get set }
    
    func startObserving()
    
    func loadPosts() async
    func delete(post: Post)
    func save(post: Post)
    
    func goToAddPost()
}

final class PostListViewModel: PostListViewModelProtocol {
    
    private let postsRepositoryManager: PostRepositoryManagerProtocol
    private var postDatabaseObserver: PostDatabaseObserver
    private let coordinator: AppCoordinator
    
    var onReceivePosts: ((_ posts: [Post]) -> Void)?
    var onPostChange: ((ObserverChangeResult<[Post]>) -> Void)?
    var onReceiveError: ((Error) -> Void)?
    
    init(postsRepositoryManager: PostRepositoryManagerProtocol,
         postDatabaseObserver: PostDatabaseObserver,
         coordinator: AppCoordinator) {
        self.postsRepositoryManager = postsRepositoryManager
        self.postDatabaseObserver = postDatabaseObserver
        self.coordinator = coordinator
    }
    
    func startObserving() {
        do {
            postDatabaseObserver.onChange = onPostChange
            try postDatabaseObserver.startObserving()
        } catch let error {
            onReceiveError?(error)
        }
    }
    
    func loadPosts() async {
        let result = postsRepositoryManager.loadLocalPosts()
        await MainActor.run {
            switch result {
            case .success(let posts):
                onReceivePosts?(posts)
            case .failure(let error):
                onReceiveError?(error)
            }
        }
        
        await loadRemotePosts()
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
    
    private func loadRemotePosts() async {
        let result = await postsRepositoryManager.loadRemotePosts()
        await MainActor.run {
            switch result {
            case .success(_):
                break
            case .failure(let error):
                onReceiveError?(error)
            }
        }
    }
}

extension PostListViewModel {
    func goToAddPost() {
        coordinator.goToAddPost()
    }
}
