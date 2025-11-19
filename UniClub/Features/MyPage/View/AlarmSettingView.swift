//
//  AlarmSettingView.swift
//  UniClub
//
//  Created by 제욱 on 11/4/25.
//

import Foundation
import SwiftUI

struct AlarmSettingView: View {
    var body: some View {
        VStack(spacing: 16) {
            Text("알림 설정")
                .font(.system(size: 20, weight: .bold))
            Text("알림 설정 화면입니다.")
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
        .navigationTitle("알림 설정")
    }
}

#Preview {
    NavigationView { AlarmSettingView() }
}
