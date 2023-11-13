import Foundation

struct PostsRequest: ApiRequest {
    typealias Response = [PostResponse]
    
    var resourceName: String {
        "/posts"
    }
}
