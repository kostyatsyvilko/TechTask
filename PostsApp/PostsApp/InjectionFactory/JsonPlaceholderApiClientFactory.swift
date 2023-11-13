import Foundation

enum JsonPlaceholderApiClientFactory {
    static func create() -> ApiClient {
        let apiManager = UrlSessionManager()
        return JsonPlaceholderClient(apiManager: apiManager)
    }
}
