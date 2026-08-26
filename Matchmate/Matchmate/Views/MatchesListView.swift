import SwiftUI

struct MatchesListView: View {
    @State private var users: [MatchUser] = []

    private let apiClient: APIClient = APIService()

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 16) {
                    ForEach(users) { user in
                        MatchCardView(user: user)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .background(Color(.systemGroupedBackground))
            .navigationTitle("Matches")
            .task {
                await load()
            }
        }
    }

    private func load() async {
        do {
            let response: RandomUserResponse = try await apiClient.request(endpoint: MatchUserEndpoint(count: 10))
            users = response.results.map(MatchUser.init(api:))
        } catch {
            print("Failed to load matches:", error)
        }
    }
}

#Preview {
    MatchesListView()
}
