import Foundation

final class PostRepositoryManager: PostRepositoryManagerProtocol {
    private let localRepository: PostLocalRepositoryProtocol
    private let remoteRepository: PostRemoteRepositoryProtocol
    
    init(localRepository: PostLocalRepositoryProtocol,
         remoteRepository: PostRemoteRepositoryProtocol) {
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
    
    func saveLocal(post: Post) throws {
        try localRepository.save(post: post)
    }
    
    func deleteLocal(post: Post) throws {
        try localRepository.delete(post: post)
    }
}
