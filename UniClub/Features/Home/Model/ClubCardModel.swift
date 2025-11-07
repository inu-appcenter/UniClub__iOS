import Foundation

struct ClubCardModel: Identifiable, Equatable {
    let id: Int
    let name: String
    var favorit: Bool
    var imageURL: URL?
}


@MainActor
final class ClubCardViewModel: ObservableObject {
    @Published private(set) var clubs: [ClubCardModel] = []
    @Published var isLoadingMore = false
    @Published var lastError: String?

    init() { Task { await loadInitial() } }

    func toggleLike(for clubID: Int) {
        guard let i = clubs.firstIndex(where: { $0.id == clubID }) else { return }
        clubs[i].favorit.toggle()
    }

    func loadMoreIfNeeded(currentItem: ClubCardModel) {
        // 페이징 필요 시 구현
    }

    func loadInitial() async {
        guard clubs.isEmpty else { return }
        isLoadingMore = true
        defer { isLoadingMore = false }

        do {
            let dtos: [MainClubDTO] = try await HTTPClient.shared.getFlexibleArray(AppConfig.API.Main.clubs, as: MainClubDTO.self)
            self.clubs = dtos.enumerated().map { i, dto in
                ClubCardModel(
                    id: i + 1,
                    name: dto.name,
                    favorit: dto.favorite ?? false,
                    imageURL: dto.imageUrl?.asAbsoluteURL(base: AppConfig.baseURL)
                )
            }
            lastError = nil
        } catch APIError.badResponse(let status, let body) {
            lastError = "서버 오류 \(status)"
            print("🧩 서버 메시지:", body)
            self.clubs = []
        } catch {
            lastError = "네트워크/디코딩 오류"
            print("❗️", error)
            self.clubs = []
        }
    }
}
