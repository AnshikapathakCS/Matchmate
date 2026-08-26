import Foundation

protocol MatchesRepositoryProtocol {
    func fetchMatches() async throws -> [MatchUser]
}

final class MatchesRepository: MatchesRepositoryProtocol {
    private let apiClient: APIClient

    init(apiClient: APIClient = APIService()) {
        self.apiClient = apiClient
    }

    func fetchMatches() async throws -> [MatchUser] {
        let response: RandomUserResponse = try await apiClient.request(endpoint: MatchUserEndpoint(count: 10))
        return response.results.map(MatchUser.init(api:))
    }
}
