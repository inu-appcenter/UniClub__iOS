import Foundation

@MainActor
class ClubDetailViewModel: ObservableObject {
    
    @Published var club: ClubDetail?
    @Published var isLoading = true
    @Published var errorMessage: String?
    @Published var toastMessage: String?
    
    func fetchClubData(clubId: Int) async {
        isLoading = true
        errorMessage = nil
        
        do {
            club = try await NetworkGateway.fetchClubDetail(clubId: clubId)
        }
        catch let error as GatewayFault {
            errorMessage = "데이터 로딩에 실패했습니다: \(error)"
        } catch {
            errorMessage = "알 수 없는 오류: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    func toggleFavorite() async {
        guard var currentClub = self.club else { return }
        
        let originalClubState = self.club
        let isNowFavorite = !currentClub.favorite
        
        // 낙관적 업데이트
        currentClub.favorite = isNowFavorite
        self.club = currentClub
        
        do {
            _ = try await NetworkGateway.toggleFavoriteStatus(clubId: currentClub.id)
            toastMessage = isNowFavorite ? "관심 동아리에 추가됨" : "관심 동아리에서 제거됨"
        } catch {
            // 실패 시 롤백
            self.club = originalClubState
            toastMessage = "즐겨찾기 변경에 실패했습니다."
        }
    }
}
