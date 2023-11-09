import Foundation

protocol PostListViewModelProtocol {
    var onReceivePosts: (@MainActor (_ posts: [Post]) -> Void)? { get set }
    
    func loadRemotePosts() async
    func loadLocalPosts()
}

final class PostListViewModel: PostListViewModelProtocol {
    
    private let postsRemoteRepository: PostsRepositoryProtocol
    
    var onReceivePosts: (@MainActor (_ posts: [Post]) -> Void)?
    
    init(postsRemoteRepository: PostsRepositoryProtocol) {
        self.postsRemoteRepository = postsRemoteRepository
    }
    
    func loadRemotePosts() async {
        let result = await postsRemoteRepository.loadPosts()
        switch result {
        case .success(let posts):
            await onReceivePosts?(posts)
        case .failure(let error):
            debugPrint(error)
        }
    }
    
    func loadLocalPosts() {}
}
