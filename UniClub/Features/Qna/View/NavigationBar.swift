//
//  NavigationBar.swift
//  UniClub
//
//  Created by 제욱 on 11/8/25.
//

import Foundation
import SwiftUI


struct NavigationBar: View {
    let title: String
    let leadingAction: () -> Void

    var body: some View {
        HStack {
            Button(action: leadingAction) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 20))
                    .foregroundColor(.black)
            }
            Spacer()
            Text(title)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.black)
            Spacer()
            Rectangle()
                .fill(Color.clear)
                .frame(width: 20, height: 20)
        }
        .padding(.horizontal)
        .padding(.vertical, 10)
    }
}
