import SwiftUI

struct ClubRowView: View {
    let item: ClubListItem

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color.gray.opacity(0.65))
                .shadow(color: .black.opacity(0.25), radius: 13.4, x: 0, y: 0)
                .frame(height: 71)

            HStack(spacing: 14) {
                // 썸네일
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.white)
                        .frame(width: 54, height: 53)
                        .shadow(color: .black.opacity(0.25), radius: 3.6, x: 0, y: 4)

                    if let url = item.profileURL {
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                            case .empty:
                                Color.white.opacity(0.001)
                            case .failure:
                                Image(systemName: "photo")
                                    .resizable()
                                    .scaledToFit()
                                    .padding(10)
                            @unknown default:
                                Color.gray.opacity(0.2)
                            }
                        }
                        .frame(width: 54, height: 53)
                        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
                    }
                }

                // 중앙 텍스트
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.name)
                        .font(.system(size: 14, weight: .medium))
                        .kerning(-0.15)
                        .foregroundStyle(.white)
                        .lineLimit(1)

                    Text(item.info?.isEmpty == false ? item.info! : "추가정보")
                        .font(.system(size: 11, weight: .medium))
                        .kerning(-0.12)
                        .foregroundStyle(.white)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // 우측 아이콘
                VStack(spacing: 8) {
                    (item.favorite == true ? Image(systemName: "heart.fill") : Image(systemName: "heart"))
                        .imageScale(.small)
                        .foregroundStyle(.white)
                        .frame(height: 11)

                    Image(systemName: "chevron.right")
                        .imageScale(.small)
                        .foregroundStyle(.white.opacity(0.9))
                        .frame(height: 11)
                }
                .frame(width: 35)
                .contentShape(Rectangle()) // 터치 영역 확보
            }
            .padding(.horizontal, 17)
        }
    }
}

#Preview {
    ClubRowView(item: .init(
        id: 1,
        name: "appcenter(앱센터)",
        info: "신입 회원 모집 중",
        status: "ACTIVE",
        favorite: true,
        category: .liberalAcademic,
        clubProfileUrl: ""
    ))
    .padding()
    .background(Color.white)
}
