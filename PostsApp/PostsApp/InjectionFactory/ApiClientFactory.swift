import Foundation

enum ApiClientFactory {
    static func createPostRepository() -> ApiClient {
        let apiManager = UrlSessionManager()
        return PostRepository(apiManager: apiManager)
    }
}
