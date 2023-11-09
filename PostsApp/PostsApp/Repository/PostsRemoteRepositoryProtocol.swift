import Foundation

protocol PostsRemoteRepositoryProtocol {
    func loadPosts() async -> PostsResultType
}

