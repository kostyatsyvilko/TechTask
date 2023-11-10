import Foundation

protocol ApiRequest {
    associatedtype Response: Decodable
    
    var resourceName: String { get }
}
