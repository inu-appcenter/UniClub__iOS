//
//  HeaderView.swift
//  UniClub
//

import SwiftUI

struct HeaderView: View {
    var body: some View {
        HStack {
            // 앱 로고 버튼 (추후 탭 시 동작 연결 가능)
            Button(action: {}) {
                Image("Logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 24) // 로고 자체 높이만 살짝 제어
            }

            Spacer()

            // 검색 아이콘
            Button(action: {}) {
                Image("Icon_search")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 23)
            }

            // 알림 아이콘
            Button(action: {}) {
                Image("Icon_alarm")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 21)
                    .padding(.leading, 22) // 검색 아이콘과의 간격
            }
        }
        .background(Color.white)
        .padding(.horizontal, 18)
    }
}

#Preview {
    HeaderView()
        .background(Color.gray)
}
