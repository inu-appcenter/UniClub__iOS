import SwiftUI
import UIKit

@MainActor
class ClubEditViewModel: ObservableObject {
    
    // MARK: - Published Properties
    @Published var name: String = ""
    @Published var simpleDescription: String = ""
    @Published var description: String = ""
    @Published var location: String = ""
    @Published var presidentName: String = ""
    @Published var presidentPhone: String = ""
    @Published var notice: String = ""
    
    // RecruitmentStatus enum이 어딘가에 정의되어 있다고 가정합니다.
    @Published var recruitmentStatus: RecruitmentStatus = .ACTIVE
    
    @Published var applyLink: String = ""
    @Published var youtubeLink: String = ""
    @Published var instagramLink: String = ""
    
    // 서버 통신용 (String)
    @Published var startTime: String = ""
    @Published var endTime: String = ""

    // UI DatePicker용 (Date)
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    
    // UI 이미지용 (UIImage)
    @Published var bannerImage: UIImage?
    @Published var profileImage: UIImage?
    @Published var galleryImages: [UIImage] = []
    
    // 상태 관리
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var clubId: Int?
    
    // MARK: - Date Formatter
    private let serverDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    // MARK: - Fetch Data
    func fetchData(clubId: Int) async {
        self.clubId = clubId
        isLoading = true
        errorMessage = nil
        
        do {
            let clubDetail = try await NetworkGateway.fetchClubDetail(clubId: clubId)
            
            self.name = clubDetail.name
            self.simpleDescription = clubDetail.simpleDescription ?? ""
            self.description = clubDetail.description
            self.location = clubDetail.location
            self.presidentName = clubDetail.presidentName
            self.presidentPhone = clubDetail.presidentPhone
            self.notice = clubDetail.notice
            self.recruitmentStatus = clubDetail.status
            self.applyLink = clubDetail.applicationFormLink
            self.youtubeLink = clubDetail.youtubeLink
            self.instagramLink = clubDetail.instagramLink

            // 날짜 변환 (String -> Date)
            self.startDate = serverDateFormatter.date(from: clubDetail.startTime) ?? Date()
            self.endDate = serverDateFormatter.date(from: clubDetail.endTime) ?? Date()
            
            // 원본 String 저장
            self.startTime = clubDetail.startTime
            self.endTime = clubDetail.endTime

            // 이미지 초기화 (필요시 URL 로드 로직 추가 필요)
            self.bannerImage = nil
            self.profileImage = nil
            self.galleryImages = []
            
        } catch {
            self.errorMessage = "데이터를 불러오지 못했습니다: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - Save Changes
    func saveChanges() async -> Bool {
        guard let clubId = clubId else {
            errorMessage = "동아리 ID가 없습니다."
            return false
        }
        
        isLoading = true
        errorMessage = nil
        
        // DatePicker의 Date를 서버 포맷 String으로 변환
        self.startTime = serverDateFormatter.string(from: self.startDate)
        self.endTime = serverDateFormatter.string(from: self.endDate)
        
        let updatedData = UpdateClubRequest(
            name: self.name,
            status: self.recruitmentStatus,
            startTime: self.startTime,
            endTime: self.endTime,
            simpleDescription: self.simpleDescription,
            description: self.description,
            notice: self.notice,
            location: self.location,
            presidentName: self.presidentName,
            presidentPhone: self.presidentPhone,
            youtubeLink: self.youtubeLink,
            instagramLink: self.instagramLink,
            applicationFormLink: self.applyLink
        )
        
        var success = false
        
        do {
            // 성공 여부 반환 (Bool 가정)
            success = try await NetworkGateway.updateClubDetail(clubId: clubId, clubData: updatedData)
            
            if !success {
                errorMessage = "저장에 실패했습니다 (서버 응답 False)."
            }
            
        } catch let error as GatewayFault {
            // 게이트웨이 커스텀 에러 처리
            switch error {
            case .serverErrorWithBody(let code, let body):
                errorMessage = "저장 실패 [\(code)]\n\(body)"
            case .serverError(let code):
                errorMessage = "저장 실패 [\(code)]"
            case .networkError(let netError):
                errorMessage = "네트워크 오류: \(netError.localizedDescription)"
            case .decodingError:
                errorMessage = "응답 데이터 오류"
            default:
                errorMessage = "알 수 없는 게이트웨이 오류"
            }
            success = false
            
        } catch {
            // 일반 에러 처리
            errorMessage = "알 수 없는 오류: \(error.localizedDescription)"
            success = false
        }
        
        isLoading = false
        return success
    }
    
    // MARK: - Helper Methods
    func addGalleryImage(_ image: UIImage) {
        galleryImages.append(image)
    }
    
    func removeGalleryImage(_ image: UIImage) {
        galleryImages.removeAll(where: { $0 == image })
    }
}
