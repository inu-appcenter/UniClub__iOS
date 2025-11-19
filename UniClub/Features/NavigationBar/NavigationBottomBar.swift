//
//  NavigationBottomBar.swift
//  UniClub
//
//  Created by 제욱 on 11/18/25.
//

import Foundation
import SwiftUI

struct RoundedCorners: Shape {
    var radius: CGFloat = 12
    var corners: UIRectCorner = [.topLeft, .topRight]
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

enum MainTab: Int {
    case qna = 0
    case home = 1
    case mypage = 2
}

struct NavigationBottomBar: View {
    @Binding var selection: MainTab

    var body: some View {
        HStack(spacing: 0) {
            Spacer()
            navButton(title: "질의응답", tab: .qna, systemImage: "questionmark.bubble")
            Spacer()
            navButton(title: "홈", tab: .home, systemImage: "house")
            Spacer()
            navButton(title: "마이페이지", tab: .mypage, systemImage: "person")
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 89)
        .background(
            RoundedCorners(radius: 12, corners: [.topLeft, .topRight])
                .fill(Color.black.opacity(0.6))
                .ignoresSafeArea(edges: .bottom)
        )
        .padding(.bottom, -safeAreaBottom())
        .shadow(color: Color.black.opacity(0.15), radius: 8, x: 0, y: 4)
    }

    @ViewBuilder
    private func navButton(title: String, tab: MainTab, systemImage: String) -> some View {
        Button(action: { selection = tab }) {
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(selection == tab ? .white : Color.white.opacity(0.7))
                Text(title)
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(selection == tab ? .white : Color.white.opacity(0.7))
            }
            .padding(.vertical, 6)
            .frame(minWidth: 60)
            .contentShape(Rectangle())
        }
    }

    private func safeAreaBottom() -> CGFloat {
        // approximate safe area bottom inset
        let keyWindow = UIApplication.shared.connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .flatMap { $0.windows }
            .first { $0.isKeyWindow }
        return keyWindow?.safeAreaInsets.bottom ?? 0
    }
}

#Preview {
    NavigationBottomBar(selection: .constant(.home))
        .preferredColorScheme(.dark)
        .frame(height: 89)
}
