import Foundation

final class APIService: APIClient {
    func request<T: Decodable>(endpoint: Endpoint) async throws -> T {
        let (data, response) = try await URLSession.shared.data(for: endpoint.makeRequest())

        guard let http = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        guard (200..<300).contains(http.statusCode) else {
            throw NetworkError.serverError(http.statusCode)
        }

        return try JSONDecoder().decode(T.self, from: data)
    }
}
