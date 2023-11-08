import Foundation

enum JsonPlaceholderError: Error {
    case encoding
    case decoding
    case incorrectUrl
    case server(message: Error)
}
