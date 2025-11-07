import Foundation

@MainActor
class ClubDetailViewModel: ObservableObject {
    
    @Published var club: ClubDetail?
    @Published var isLoading = true
    @Published var errorMessage: String?
    @Published var toastMessage: String?
    
    func fetchClubData(clubId: Int) async {
        if isLoading == false && club != nil { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            // 토큰 없이 NetworkGateway 함수를 호출합니다.
            club = try await NetworkGateway.fetchClubDetail(clubId: clubId)
        }
        catch let error as GatewayFault {
            print("A GatewayFault occurred: \(error)")
            errorMessage = "데이터 로딩에 실패했습니다: \(error)"
        } catch {
            print("An unknown error occurred: \(error)")
            errorMessage = "알 수 없는 오류: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func toggleFavorite() async {
        guard var currentClub = self.club else { return }
        
        // TODO: NetworkGateway에 관심 동아리 API 호출 로직 추가 (필요 시)
        
        let isNowFavorite = !currentClub.favorite
        currentClub.favorite = isNowFavorite
        self.club = currentClub
        
        toastMessage = isNowFavorite ? "관심 동아리에 추가됨" : "관심 동아리에서 제거됨"
    }
}
