import Foundation

protocol APIClient {
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T
}
