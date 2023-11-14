import Foundation
@testable import PostsApp

final class PostRepositoryMock: ApiClient {
    func send<T>(_ request: T) async -> PostsApp.ApiClientResult<T.Response> where T : PostsApp.ApiRequest {
        let mockData = [
            ["title": "Title", "body": "Body"]
        ]
        
        let data = try? JSONSerialization.data(withJSONObject: mockData)
        
        guard let data else {
            return .failure(ApiError.encoding)
        }
        
        let model = try? JSONDecoder().decode(T.Response.self, from: data)
        
        if let model {
            return .success(model)
        } else {
            return .failure(ApiError.decoding)
        }
    }
}
