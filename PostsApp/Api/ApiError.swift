import Foundation

enum ApiError: LocalizedError {
    case encoding
    case decoding
    case incorrectUrl
    case server(message: Error)
    
    var errorDescription: String? {
        switch self {
        case .encoding:
            return "Cannot encode value"
        case .decoding:
            return "Cannot decode value"
        case .incorrectUrl:
            return "Incorrect url"
        case .server(let message):
            return message.localizedDescription
        }
    }
}
