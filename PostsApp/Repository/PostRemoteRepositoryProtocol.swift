import Foundation

protocol PostRemoteRepositoryProtocol {
    func loadPosts() async -> PostsResultType
}
