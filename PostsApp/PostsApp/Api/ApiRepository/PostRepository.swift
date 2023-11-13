import Foundation

class PostRepository: ApiClient {
    
    private let apiManager: ApiManager
    private let baseUrlString = ApiConfig.baseUrlString
    
    init(apiManager: ApiManager) {
        self.apiManager = apiManager
    }
    
    func send<T>(_ request: T) async -> ApiClientResult<T.Response> where T : ApiRequest {
        guard let url = URL(string: baseUrlString + request.resourceName) else {
            return .failure(JsonPlaceholderError.incorrectUrl)
        }
        let result = await apiManager.send(url: url, headers: [:])
        
        switch result {
        case .success(let data):
            let model = try? JSONDecoder().decode(T.Response.self, from: data)
            
            if let model = model {
                return .success(model)
            } else {
                return .failure(JsonPlaceholderError.decoding)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
