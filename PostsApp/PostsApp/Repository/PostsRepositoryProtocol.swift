import Foundation

typealias PostsResult = Result<[Post], Error>

protocol PostsRepositoryProtocol {
    func loadPosts() async -> PostsResult
}

