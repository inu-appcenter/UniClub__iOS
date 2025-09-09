import SwiftUI

struct ClubCard: View {
    let club: ClubCardModel
    let onLikeToggle: () -> Void

    var body: some View {
        ZStack {
            if let url = club.imageURL {
                AsyncImage(url: url) { phase in
                    switch phase {
                    case .success(let image): image.resizable().scaledToFill()
                    case .empty: Color.gray.opacity(0.25)
                    case .failure: Color.gray.opacity(0.35)
                    @unknown default: Color.gray.opacity(0.25)
                    }
                }
                .frame(width: 136, height: 206)
                .clipShape(RoundedRectangle(cornerRadius: 17))
            } else {
                RoundedRectangle(cornerRadius: 17)
                    .fill(Color.white.opacity(0.55))
                    .frame(width: 136, height: 206)
            }
        }
        .overlay(alignment: .topLeading) {
            Text(club.name)
                .font(Font.custom("NotoSansKR-Medium", size: 13).weight(.medium))
                .foregroundColor(.white)
                .frame(width: 72, alignment: .topLeading)
                .lineLimit(2)
                .multilineTextAlignment(.leading)
                .padding(.top, 12)
                .padding(.leading, 12)
                .shadow(radius: 2)
        }
        .overlay(alignment: .topTrailing) {
            Button(action: onLikeToggle) {
                Image(systemName: club.favorit ? "heart.fill" : "heart")
                    .font(.title3)
                    .foregroundColor(club.favorit ? .red : .white)
                    .shadow(radius: 2)
                    .padding(8)
            }
            .buttonStyle(.plain)
            .padding(.top, 6)
            .padding(.trailing, 6)
        }
        .contentShape(RoundedRectangle(cornerRadius: 17))
    }
}

struct ClubCardView: View {
    @StateObject private var vm = ClubCardViewModel()

    var body: some View {
        Group {
            if let error = vm.lastError {
                // ❌ 에러 상태
                VStack {
                    Image(systemName: "exclamationmark.triangle")
                        .font(.largeTitle)
                        .foregroundColor(.orange)
                    Text(error).font(.callout).foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, minHeight: 120)

            } else if vm.clubs.isEmpty {
                // 📭 빈 상태
                VStack {
                    Image(systemName: "tray")
                        .font(.largeTitle)
                        .foregroundColor(.gray)
                    Text("등록된 동아리가 없습니다.")
                        .font(.callout)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, minHeight: 120)

            } else {
                // ✅ 정상 데이터
                ScrollView(.horizontal, showsIndicators: false) {
                    LazyHStack(spacing: 15) {
                        ForEach(vm.clubs) { item in
                            ClubCard(club: item, onLikeToggle: { vm.toggleLike(for: item.id) })
                                .onAppear { vm.loadMoreIfNeeded(currentItem: item) }
                        }

                        if vm.isLoadingMore {
                            ProgressView().frame(width: 120, height: 120)
                        }
                    }
                    .padding(.vertical, 12)
                }
            }
        }
    }
}
