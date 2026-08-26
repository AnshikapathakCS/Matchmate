import Foundation

@Observable
@MainActor
final class MatchesViewModel {
    private(set) var users: [MatchUser] = []
    private(set) var isLoading = false
    private(set) var errorMessage: String?

    private let repository: MatchesRepositoryProtocol

    init(repository: MatchesRepositoryProtocol = MatchesRepository()) {
        self.repository = repository
    }

    func load() async {
        isLoading = true
        errorMessage = nil
        do {
            users = try await repository.fetchMatches()
        } catch {
            errorMessage = error.localizedDescription
        }
        isLoading = false
    }
}
