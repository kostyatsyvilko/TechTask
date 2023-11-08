import Foundation

enum DatabaseError: Error {
    case save
    case incorrectModel
    case delete
    case fetch
}
