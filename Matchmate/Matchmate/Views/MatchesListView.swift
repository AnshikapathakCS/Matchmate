import SwiftUI

struct MatchesListView: View {
    @State private var viewModel = MatchesViewModel()

    var body: some View {
        NavigationStack {
            content
                .background(Color(.systemGroupedBackground))
                .navigationTitle("Matches")
                .task {
                    await viewModel.load()
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        if viewModel.isLoading && viewModel.users.isEmpty {
            loadingView
        } else if let message = viewModel.errorMessage, viewModel.users.isEmpty {
            errorView(message: message)
        } else {
            cardsList
        }
    }

    private var loadingView: some View {
        ProgressView("Finding matches…")
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func errorView(message: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "wifi.exclamationmark")
                .font(.largeTitle)
                .foregroundStyle(.secondary)

            Text("Something went wrong")
                .font(.headline)

            Text(message)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)

            Button("Try Again") {
                Task { await viewModel.load() }
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 4)
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private var cardsList: some View {
        ScrollView {
            LazyVStack(spacing: 16) {
                ForEach(viewModel.users) { user in
                    MatchCardView(
                        user: user,
                        onAccept: { viewModel.updateStatus(for: user.id, to: .accepted) },
                        onDecline: { viewModel.updateStatus(for: user.id, to: .declined) }
                    )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
        }
    }
}

#Preview {
    MatchesListView()
}
