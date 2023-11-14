import Foundation
@testable import PostsApp

final class PostRemoteRepositoryMock: PostRemoteRepositoryProtocol {
    func loadPosts() async -> PostsApp.PostsResultType {
        let posts = [
            Post(title: "TitleRemote1", body: "Body"),
            Post(title: "TitleRemote2", body: "Body"),
            Post(title: "TitleRemote3", body: "Body")
        ]
        
        return .success(posts)
    }
}
