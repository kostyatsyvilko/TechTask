import Foundation

struct JsonPlaceholderApiClientFactory {
    static func create() -> ApiClient {
        let apiManager = UrlSessionManager()
        return JsonPlaceholderClient(apiManager: apiManager)
    }
}
