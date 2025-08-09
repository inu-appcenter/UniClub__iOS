//
//  MainView.swift
//  ProjectTest
//
//  Created by 제욱 on 7/20/25.
//

import SwiftUI
struct MainView: View {
    var body: some View {
        ScrollView(.vertical, showsIndicators: true) {
            VStack(spacing: 24) {
                // 상단 바
                TopHeaderView()
                    .frame(height: 80)
                    .padding(.horizontal)
                    .background(Color.white)

                // 배너
                TopBannerView()
    
                // 타이틀
                Text("이런 동아리는 어떠세요?")
                  .font(
                    Font.custom("Noto Sans KR", size: 16)
                      .weight(.bold)
                  )
                  .foregroundColor(.black)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 8)

                // ✅ 여기 보이게 됨 (가로 스크롤은 내부에서 처리)
                ClubCardView()

                HStack {
                    Text("카테고리")
                      .font(
                        Font.custom("Noto Sans KR", size: 16)
                          .weight(.bold)
                      )
                      .foregroundColor(.black)

                    Spacer()

                    Text("전체보기")
                      .font(
                        Font.custom("Noto Sans KR", size: 11)
                          .weight(.medium)
                      )
                      .foregroundColor(Color(red: 0.75, green: 0.75, blue: 0.75))
                }
                .padding(.top, 8)

                CategoryButtonsView()
            }
            .padding(.horizontal)
            .padding(.bottom, 32)
        }
    }
}

#Preview(){
    MainView()
}
