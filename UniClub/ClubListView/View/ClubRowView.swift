import SwiftUI

struct ClubRowView: View {
    let item: ClubListItem

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 28, style: .continuous)
                .fill(Color(hex: "FF7600"))
                .shadow(color: .black.opacity(0.25), radius: 13.4, x: 0, y: 0)
                .frame(height: 71)
                .padding(.horizontal, 17)

            HStack(spacing: 20) {
                // 썸네일
                ZStack {
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .fill(Color.white)
                        .frame(width: 54, height: 53)
                        .shadow(color: .black.opacity(0.25), radius: 3.6, x: 0, y: 4)
                        .padding(.leading, 25)

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
                        .font(.custom("NotoSansKR-Bold", size: 14))
                        .foregroundStyle(.white)
                        .lineLimit(1)

                    Text(item.info?.isEmpty == false ? item.info! : "추가정보")
                        .font(.custom("NotoSansKR-medium", size: 9))
                        .foregroundStyle(.white)
                        .lineLimit(2)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                // 우측 아이콘
                VStack(spacing: 20) {
                (item.favorite == true ? Image(systemName: "heart.fill") :
                    Image(systemName: "heart"))
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
                .padding(.trailing, 35)
            }
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
    .background(Color.gray)
}
