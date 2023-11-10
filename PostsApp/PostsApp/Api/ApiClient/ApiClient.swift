import Foundation

public typealias ApiClientResult<Value> = Result<Value, Error>

protocol ApiClient {
    func send<T: ApiRequest>(_ request: T) async -> ApiClientResult<T.Response>
}
