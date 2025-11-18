//
//  MyPageEditProfileView.swift
//  UniClub
//
//  Created by 제욱 on 11/4/25.
//

import Foundation
import SwiftUI

struct EditProfileView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("프로필 수정")
                .font(.system(size: 20, weight: .bold))
            Text("프로필을 수정하는 화면입니다.")
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
        .navigationTitle("프로필 수정")
    }
}

#Preview {
    NavigationView { EditProfileView() }
}
