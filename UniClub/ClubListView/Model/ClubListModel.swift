//
//  ClubListModel.swift
//  UniClub
//
//  Created by 제욱 on 9/9/25.
//


// Models/ClubListRowModel.swift
import Foundation

struct ClubListRowModel: Identifiable, Equatable {
    let id: Int
    let title: String          // ex) "appcenter(앱센터)"
    let subtitle: String?      // ex) "추가정보"
    let isFavorite: Bool
    let imageURL: URL?
}


// ViewModels/ClubListViewModel.swift

@MainActor
final class ClubListViewModel: ObservableObject {
    @Published private(set) var items: [ClubListItem] = []   // ← DTO 그대로

    @Published var isLoading = false
    @Published var lastError: String?

    func load(category: ClubCategory?) async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            var query: [URLQueryItem] = []
            if let category { query.append(.init(name: "category", value: category.rawValue)) }

            let res: ClubListResponse = try await HTTPClient.shared.get(
                API.Clubs.list,                            // "/api/v1/main/clubs"
                query: query.isEmpty ? nil : query,
                as: ClubListResponse.self
                

            )
            // 없는 데이터 디폴트 통일
            self.items = res.content.map { dto in
                ClubListItem(
                    id: dto.id,
                    name: dto.name,
                    info: (dto.info?.isEmpty == false) ? dto.info : "추가정보",
                    status: dto.status ?? "ACTIVE",
                    favorite: dto.favorite ?? false,
                    category: dto.category,
                    clubProfileUrl: dto.clubProfileUrl
                )
            }
            lastError = nil
        } catch APIError.badResponse(let code, let body) {
            lastError = "[HTTP \(code)] \(body)"
            self.items = []
        } catch {
            lastError = error.localizedDescription
            self.items = []
        }
    }
}

