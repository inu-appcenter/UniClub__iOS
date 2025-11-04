import SwiftUI

struct CategoryButtonsView: View {
    // 기존 그대로
    let categories = ["교양학술", "취미전시", "체육", "종교", "봉사", "문화"]
    let icons      = ["Icon_academic", "Icon_hobby", "Icon_sports", "Icon_religion", "Icon_volunteer", "Icon_culture"]

    let columns = [
        GridItem(.flexible(), spacing: 71, alignment: .center),
        GridItem(.flexible(), spacing: 71, alignment: .center),
        GridItem(.flexible(), spacing: 0,    alignment: .center)
    ]

    // ✅ 추가: 탭 콜백 (선택된 카테고리 이름 전달)
    var onSelect: ((String) -> Void)? = nil

    var body: some View {
        LazyVGrid(columns: columns, spacing: 34.6) {
            ForEach(0..<categories.count, id: \.self) { i in
                Button {
                    onSelect?(categories[i]) // ✅ 탭 시 상위로 카테고리 이름 전달
                } label: {
                    VStack(spacing: 7) {
                        ZStack {
                            Image(icons[i])
                                .resizable()
                                .scaledToFit()
                                .frame(height: 40)
                                .shadow(color: .black.opacity(0.25), radius: 2, x: 0, y: 2)
                        }
                        Text(categories[i])
                            .font(.custom("NotoSansKR-Medium", size: 11)) // ✅ PS Name 사용
                            .foregroundColor(Color(red: 0.24, green: 0.24, blue: 0.24))
                            .lineLimit(2)
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                    }
                    .frame(maxWidth: .infinity)
                    .contentShape(Circle()) // 탭 영역 넓게
                }
                .buttonStyle(.plain) // 기존 비주얼 유지
            }
        }
        .frame(maxWidth: .infinity, alignment: .center)
        .padding(.horizontal, 34)
    }
}

#Preview {
    CategoryButtonsView { _ in }
        .background(Color.gray)
}
