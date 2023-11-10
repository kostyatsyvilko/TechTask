import Foundation

typealias ApiManagerResult = Result<Data, Error>

protocol ApiManager {
    func send(url: URL, headers: [String: String]) async -> ApiManagerResult
}
