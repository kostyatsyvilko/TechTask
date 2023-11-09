import Foundation

final class PostsRepositoryManager: PostsRepositoryManagerProtocol {
    private var localRepository: PostsLocalRepositoryProtocol
    private var remoteRepository: PostsRemoteRepositoryProtocol
    
    init(localRepository: PostsLocalRepositoryProtocol,
         remoteRepository: PostsRemoteRepositoryProtocol) {
        self.localRepository = localRepository
        self.remoteRepository = remoteRepository
    }
    
    func loadRemotePosts() async -> PostsResultType {
        let result = await remoteRepository.loadPosts()
        switch result {
        case .success(let posts):
            localRepository.saveNotExists(posts: posts)
            return .success(posts)
        case .failure(let error):
            return .failure(error)
        }
    }
    
    func loadLocalPosts() -> PostsResultType {
        localRepository.loadPosts()
    }
    
    func saveLocal(post: Post) {
        localRepository.save(post: post)
    }
    
    func deleteLocal(post: Post) {
        localRepository.delete(post: post)
    }
}
