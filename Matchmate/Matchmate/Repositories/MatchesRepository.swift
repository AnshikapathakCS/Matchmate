import Foundation

protocol MatchesRepositoryProtocol {
    func fetchMatches() async throws -> [MatchUser]
    func updateStatus(for id: String, to status: MatchStatus)
}

final class MatchesRepository: MatchesRepositoryProtocol {
    private let apiClient: APIClient
    private let store: PersistenceController

    init(apiClient: APIClient = APIService(),
         store: PersistenceController = .shared) {
        self.apiClient = apiClient
        self.store = store
    }

    func fetchMatches() async throws -> [MatchUser] {
        let response: RandomUserResponse = try await apiClient.request(endpoint: MatchUserEndpoint(count: 10))
        let users = response.results.map(MatchUser.init(api:))
        store.saveUsers(users)
        return store.loadCachedUsers()
    }

    func updateStatus(for id: String, to status: MatchStatus) {
        store.updateStatus(for: id, to: status)
    }
}
