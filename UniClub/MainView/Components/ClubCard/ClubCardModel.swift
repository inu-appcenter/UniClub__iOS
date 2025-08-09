//
//  ClubCardModel.swift
//  UniClub
//
//  Created by 제욱 on 8/9/25.
//

import Foundation

struct ClubCardModel: Identifiable {
    let id: Int
    let name: String
    var isLiked: Bool
    var imageURL: URL?
}

final class ClubCardViewModel: ObservableObject {
    @Published private(set) var clubs: [ClubCardModel] = []
    @Published var isLoadingMore = false

    private var page = 0
    private let pageSize = 5
    private var hasNext = true

    init() {
        Task { await loadPage() } // 초기 5개
    }

    func loadMoreIfNeeded(currentItem item: ClubCardModel) {
        guard hasNext, !isLoadingMore else { return }
        // 마지막 아이템이 보이면 로드
        if clubs.last?.id == item.id {
            Task { await loadPage() }
        }
    }

    @MainActor
    private func loadPage() async {
        guard hasNext, !isLoadingMore else { return }
        isLoadingMore = true
        // ⬇︎ mock 지연(로딩 느낌). 실제 API 연결시 제거/대체
        try? await Task.sleep(nanoseconds: 500_000_000)

        let newItems = makeMockPage(page: page, size: pageSize)
        if newItems.isEmpty { hasNext = false }
        clubs.append(contentsOf: newItems)
        page += 1
        isLoadingMore = false
    }

    private func makeMockPage(page: Int, size: Int) -> [ClubCardModel] {
        // 예시: 3페이지까지만 데이터 제공 (총 15개)
        let startID = page * size + 1
        let endID = min(startID + size - 1, 15)
        guard startID <= endID else { return [] }
        return (startID...endID).map { i in
            ClubCardModel(
                id: i,
                name: "동아리 \(i)",
                isLiked: (i % 4 == 0),
                imageURL: URL(string: "https://picsum.photos/seed/club\(i)/200")
            )
        }
    }

    // 기존 좋아요 토글 그대로 유지
    func toggleLike(for clubID: Int) {
        guard let idx = clubs.firstIndex(where: { $0.id == clubID }) else { return }
        clubs[idx].isLiked.toggle()
    }
}

