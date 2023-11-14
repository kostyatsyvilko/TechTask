import Foundation
@testable import PostsApp

final class ApiManagerMock: ApiManager {
    func send(url: URL, headers: [String : String]) async -> PostsApp.ApiManagerResult {
        let mockData = [
            ["title": "Title", "body": "Body"]
        ]
        
        do {
            let data = try JSONSerialization.data(withJSONObject: mockData)
            
            return .success(data)
        } catch let error {
            return .failure(error)
        }
    }
}
