import Foundation

@MainActor
class ClubDetailViewModel: ObservableObject {
    
    @Published var club: ClubDetail?
    @Published var isLoading = true
    @Published var errorMessage: String?
    @Published var toastMessage: String?
    
    func fetchClubData(clubId: Int) async {
        // ⭐️ 수정됨: 화면에 진입할 때마다 최신 데이터를 불러오기 위해
        // 캐시(이미 데이터가 있으면 리턴) 로직을 제거했습니다.
        
        isLoading = true
        errorMessage = nil
        
        do {
            // NetworkGateway를 통해 데이터 가져오기
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
        
        let originalClubState = self.club
        let isNowFavorite = !currentClub.favorite
        
        // 낙관적 업데이트 (UI 먼저 반영)
        currentClub.favorite = isNowFavorite
        self.club = currentClub
        
        do {
            _ = try await NetworkGateway.toggleFavoriteStatus(clubId: currentClub.id)
            toastMessage = isNowFavorite ? "관심 동아리에 추가됨" : "관심 동아리에서 제거됨"
            
        } catch {
            print("Error toggling favorite: \(error)")
            // 실패 시 롤백
            self.club = originalClubState
            toastMessage = "즐겨찾기 변경에 실패했습니다."
        }
    }
}
