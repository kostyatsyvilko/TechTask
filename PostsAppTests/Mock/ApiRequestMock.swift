@testable import PostsApp

struct ApiRequestMock: ApiRequest {
    typealias Response = String
    
    var resourceName: String {
        ""
    }
}
