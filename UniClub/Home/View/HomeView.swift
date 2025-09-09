//
//  MainView.swift
//  ProjectTest
//
//  Created by 제욱 on 7/20/25.
//

import SwiftUI
import Foundation
struct HomeView: View {
    private let hMargin: CGFloat = 18
    private let bannerAspect: CGFloat = 324.0/249.0
    private let bannerCorner: CGFloat = 20

    // ✅ 네비게이션 경로 (nil = 전체보기)
    @State private var path: [ClubCategory?] = []

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView(.vertical, showsIndicators: true) {
                LazyVStack(spacing: 24) {
                    HeaderView()
                        .frame(maxWidth: .infinity, alignment: .leading)

                    BannerView()
                        .frame(maxWidth: .infinity)
                        .aspectRatio(bannerAspect, contentMode: .fit)
                        .clipShape(RoundedRectangle(cornerRadius: bannerCorner, style: .continuous))

                    Text("이런 동아리는 어떠세요?")
                        .font(.custom("NotoSansKR-Bold", size: 16))
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .layoutPriority(1)

                    ClubCardView()
                        .frame(maxWidth: .infinity)

                    // ✅ 전체보기 버튼 (원하시면 배치/스타일 조정)
                    Button {
                        path.append(nil)            // nil → 전체
                    } label: {
                        Text("전체보기")
                            .font(.custom("NotoSansKR-Medium", size: 14))
                    }
                    .padding(.top, 12)

                    // ✅ 카테고리 버튼들: 한글명 → Enum 매핑 후 push
                    CategoryButtonsView { name in
                        if let cat = ClubCategory(displayName: name) {
                            path.append(cat)
                        }
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 24)
                }
                .contentMargins(.horizontal, hMargin, for: .scrollContent)
                .padding(.bottom, 32)
            }
            .toolbar(.hidden, for: .navigationBar)
            .safeAreaPadding(.top)
            .safeAreaPadding(.bottom)

            // ✅ destination: ClubCategory? 타입으로 한 번에 처리
            .navigationDestination(for: ClubCategory?.self) { cat in
                ClubListView(category: cat)    // cat == nil 이면 전체
            }
        }
    }
}


#Preview {
    HomeView()
}
