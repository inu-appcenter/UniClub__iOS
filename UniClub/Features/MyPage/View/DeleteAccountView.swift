//
//  DeleteAccountView.swift
//  UniClub
//
//  Created by 제욱 on 11/4/25.
//

import Foundation
import SwiftUI

struct DeleteAccountView: View {
    var body: some View {
        VStack(spacing: 12) {
            Text("계정 삭제")
                .font(.system(size: 20, weight: .bold))
            Text("계정을 삭제하는 화면입니다.")
                .foregroundColor(.secondary)
            Spacer()
        }
        .padding()
        .navigationTitle("계정 삭제")
    }
}

#Preview {
    NavigationView { DeleteAccountView() }
}
