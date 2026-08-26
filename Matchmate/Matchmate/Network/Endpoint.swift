import Foundation

protocol Endpoint {
    var baseURL: String { get }
    var path: String { get }
    var method: HttpMethodType { get }
    var queryItems: [URLQueryItem]? { get }

    func makeRequest() throws -> URLRequest
}

extension Endpoint {
    var queryItems: [URLQueryItem]? { nil }

    func makeRequest() throws -> URLRequest {
        var components = URLComponents(string: baseURL + path)
        components?.queryItems = queryItems

        guard let url = components?.url else {
            throw NetworkError.invalidURL
        }

        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        return request
    }
}
