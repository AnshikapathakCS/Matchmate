import SwiftUI

struct MatchCardView: View {
    let user: MatchUser
    var onAccept: () -> Void = {}
    var onDecline: () -> Void = {}

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            photo
            details
            actionOrStatus
                .animation(.easeInOut(duration: 0.25), value: user.status)
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(Color(.secondarySystemBackground))
        )
    }

    @ViewBuilder
    private var actionOrStatus: some View {
        switch user.status {
        case .pending:
            actions
                .transition(.opacity)
        case .accepted:
            statusPill(text: "Member Accepted", icon: "checkmark.seal.fill", color: .pink)
                .transition(.opacity.combined(with: .scale(scale: 0.97)))
        case .declined:
            statusPill(text: "Member Declined", icon: "xmark.seal.fill", color: .secondary)
                .transition(.opacity.combined(with: .scale(scale: 0.97)))
        }
    }

    private var photo: some View {
        AsyncImage(url: URL(string: user.imageURL)) { phase in
            switch phase {
            case .empty:
                ProgressView()
                    .controlSize(.large)
            case .success(let image):
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .transition(.opacity)
            case .failure:
                Image(systemName: "person.crop.circle.badge.exclamationmark")
                    .font(.system(size: 56, weight: .light))
                    .foregroundStyle(.tertiary)
            @unknown default:
                EmptyView()
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 260)
        .background(Color(.tertiarySystemFill))
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }

    private var details: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("\(user.name), \(user.age)")
                .font(.title3.weight(.semibold))
                .foregroundStyle(.primary)

            HStack(spacing: 4) {
                Image(systemName: "mappin.and.ellipse")
                Text("\(user.city), \(user.country)")
            }
            .font(.subheadline)
            .foregroundStyle(.secondary)
        }
    }

    private var actions: some View {
        HStack(spacing: 12) {
            Button(action: onDecline) {
                Label("Decline", systemImage: "xmark")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(.red)

            Button(action: onAccept) {
                Label("Accept", systemImage: "heart.fill")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.pink)
        }
        .controlSize(.large)
    }

    private func statusPill(text: String, icon: String, color: Color) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
            Text(text).fontWeight(.semibold)
        }
        .font(.subheadline)
        .foregroundStyle(color)
        .frame(maxWidth: .infinity)
        .padding(.vertical, 12)
        .background(color.opacity(0.12), in: Capsule())
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 16) {
            MatchCardView(user: MatchUser.sampleData[0])
            MatchCardView(user: {
                var u = MatchUser.sampleData[1]; u.status = .accepted; return u
            }())
            MatchCardView(user: {
                var u = MatchUser.sampleData[2]; u.status = .declined; return u
            }())
        }
        .padding()
    }
    .background(Color(.systemGroupedBackground))
}
