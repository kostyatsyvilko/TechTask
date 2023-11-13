import Foundation

final class PostRemoteRepository: PostRemoteRepositoryProtocol {
    private let apiClient: ApiClient
    
    init(apiClient: ApiClient) {
        self.apiClient = apiClient
    }
    
    func loadPosts() async -> PostsResultType {
        let request = PostsRequest()
        let result = await apiClient.send(request)
        
        switch result {
        case .success(let remotePosts):
            let posts = remotePosts.map { Post(from: $0) }
            return .success(posts)
        case .failure(let error):
            return .failure(error)
        }
    }
}
