import SwiftUI

struct MatchesListView: View {
    private let users: [MatchUser] = MatchUser.sampleData

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
        }
    }
}

#Preview {
    MatchesListView()
}
