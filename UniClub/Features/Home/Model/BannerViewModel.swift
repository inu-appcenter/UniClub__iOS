import Foundation

struct BannerModel: Identifiable {
    let id: Int
    let imageURL: URL
}

@MainActor
final class BannerViewModel: ObservableObject {
    @Published var items: [BannerModel] = []
    @Published var isLoading = false

    func load() async {
        guard !isLoading else { return }
        isLoading = true
        defer { isLoading = false }

        do {
            let dtos: [MainBannerDTO] = try await HTTPClient.shared.getFlexibleArray(AppConfig.API.Main.banner, as: MainBannerDTO.self)
            self.items = dtos.enumerated().compactMap { idx, dto in
                dto.mediaLink.asAbsoluteURL(base: AppConfig.baseURL).map { BannerModel(id: idx, imageURL: $0) }
            }
        } catch {
            print("Banner load error:", error)
            self.items = []
        }
    }
}
