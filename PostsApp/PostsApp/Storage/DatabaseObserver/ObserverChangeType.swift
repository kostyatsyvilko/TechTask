import Foundation

enum ObserverChangeType: String {
    case update = "update"
    case delete = "delete"
    case insert = "insert"
    case unknown
}
