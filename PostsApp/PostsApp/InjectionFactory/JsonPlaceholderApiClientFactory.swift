import Foundation

enum JsonPlaceholderApiClientFactory {
    static func create() -> ApiClient {
        let apiManager = UrlSessionManager()
        return PostRepository(apiManager: apiManager)
    }
}
