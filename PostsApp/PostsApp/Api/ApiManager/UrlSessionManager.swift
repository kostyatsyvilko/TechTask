import Foundation

final class UrlSessionManager: ApiManager {
    
    private var session: URLSession
    
    init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func send(url: URL, headers: [String : String]) async -> ApiManagerResult {
        let request = URLRequest(url: url)
        do {
            let result = try await session.data(for: request)
            let data = result.0
            
            return .success(data)
        } catch let error {
            return .failure(error)
        }
    }
}
