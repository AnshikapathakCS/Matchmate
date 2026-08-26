import Foundation

protocol MatchesRepositoryProtocol {
    func loadMatches() -> AsyncThrowingStream<[MatchUser], Error>
    func updateStatus(for id: String, to status: MatchStatus)
}

final class MatchesRepository: MatchesRepositoryProtocol {
    private let apiClient: APIClient
    private let store: PersistenceController
    private let network: NetworkMonitor

    init(apiClient: APIClient = APIService(),
         store: PersistenceController = .shared,
         network: NetworkMonitor = .shared) {
        self.apiClient = apiClient
        self.store = store
        self.network = network
    }

    func loadMatches() -> AsyncThrowingStream<[MatchUser], Error> {
        AsyncThrowingStream { continuation in
            Task { @MainActor in
                let cached = store.loadCachedUsers()
                if !cached.isEmpty {
                    continuation.yield(cached)
                }

                guard network.isOnline else {
                    cached.isEmpty
                        ? continuation.finish(throwing: NetworkError.offline)
                        : continuation.finish()
                    return
                }

                do {
                    let response: RandomUserResponse = try await apiClient.request(endpoint: MatchUserEndpoint(count: 10))
                    let users = response.results.map(MatchUser.init(api:))
                    store.saveUsers(users)
                    continuation.yield(store.loadCachedUsers())
                    continuation.finish()
                } catch {
                    cached.isEmpty
                        ? continuation.finish(throwing: error)
                        : continuation.finish()
                }
            }
        }
    }

    func updateStatus(for id: String, to status: MatchStatus) {
        store.updateStatus(for: id, to: status)
    }
}
