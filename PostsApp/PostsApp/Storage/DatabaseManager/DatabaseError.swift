import Foundation

enum DatabaseError: Error, LocalizedError {
    case save
    case incorrectModel
    case delete
    case fetch
    case exists
    
    var errorDescription: String? {
        switch self {
        case .save:
            return "Cannot save data"
        case .incorrectModel:
            return "Incorrect model data"
        case .delete:
            return "Cannot delete data"
        case .fetch:
            return "Cannot fetch data"
        case .exists:
            return "Cannot check if data exists"
        }
    }
}
