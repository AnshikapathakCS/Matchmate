import Foundation

enum NetworkError: LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(Int)

    var errorDescription: String? {
        switch self {
        case .invalidURL:           return "The request URL was invalid."
        case .invalidResponse:      return "The server returned an unexpected response."
        case .serverError(let code): return "Server returned status \(code)."
        }
    }
}
