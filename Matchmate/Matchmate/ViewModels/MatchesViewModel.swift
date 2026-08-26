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
        isLoading = users.isEmpty
        errorMessage = nil
        do {
            for try await batch in repository.loadMatches() {
                users = batch
                isLoading = false
            }
        } catch {
            if users.isEmpty {
                errorMessage = error.localizedDescription
            }
        }
        isLoading = false
    }

    func updateStatus(for id: String, to status: MatchStatus) {
        guard let index = users.firstIndex(where: { $0.id == id }) else { return }
        users[index].status = status
        repository.updateStatus(for: id, to: status)
    }
}
