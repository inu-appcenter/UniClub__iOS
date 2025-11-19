//
//  ContactUsView.swift
//  UniClub
//
//  Created by 제욱 on 11/4/25.
//

import Foundation
import SwiftUI

struct ContactUsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("문의하기")
                .font(.system(size: 20, weight: .bold))
            Text("문의하기 화면입니다.")
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
        .navigationTitle("문의하기")
    }
}

#Preview {
    NavigationView { ContactUsView() }
}
