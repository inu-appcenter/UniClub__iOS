//
//  TopBannerViewModel.swift
//  UniClub
//
//  Created by 제욱 on 8/5/25.
//

import Foundation



import SwiftUI

struct BannerImage: Identifiable {
    let id: Int
    let imageURL: URL
}

final class TopBannerViewModel: ObservableObject {
    @Published var items: [BannerImage] = []

    init() {
        loadMockData()
        // 나중에 API 붙일 땐 여기서 네트워크 호출
    }

    private func loadMockData() {
        items = [
            BannerImage(id: 1, imageURL: URL(string: "https://picsum.photos/seed/b1/800/400")!),
            BannerImage(id: 2, imageURL: URL(string: "https://picsum.photos/seed/b2/800/400")!),
            BannerImage(id: 3, imageURL: URL(string: "https://picsum.photos/seed/b3/800/400")!),
            BannerImage(id: 4, imageURL: URL(string: "https://picsum.photos/seed/b4/800/400")!),
            BannerImage(id: 5, imageURL: URL(string: "https://picsum.photos/seed/b5/800/400")!)
        ]
    }
}

