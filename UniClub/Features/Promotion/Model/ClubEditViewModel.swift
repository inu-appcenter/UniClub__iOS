import SwiftUI
import UIKit

@MainActor
class ClubEditViewModel: ObservableObject {
    
    @Published var name: String = ""
    @Published var simpleDescription: String = ""
    @Published var description: String = ""
    @Published var location: String = ""
    @Published var presidentName: String = ""
    @Published var presidentPhone: String = ""
    @Published var notice: String = ""
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
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    private var clubId: Int?
    
    // 서버 날짜 형식 (yyyy-MM-dd'T'HH:mm:ss)
    private let serverDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
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
            self.startTime = clubDetail.startTime
            self.endTime = clubDetail.endTime
            
            // 초기화 (이미지 로드는 별도 구현 필요)
            self.bannerImage = nil
            self.profileImage = nil
            self.galleryImages = []
            
        } catch {
            errorMessage = "데이터 로드 실패: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func saveChanges() async -> Bool {
        guard let clubId = clubId else { return false }
        isLoading = true
        errorMessage = nil
        
        // 날짜 변환 (Date -> String)
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
            success = try await NetworkGateway.updateClubDetail(clubId: clubId, clubData: updatedData)
        } catch let error as GatewayFault {
            switch error {
            case .serverErrorWithBody(_, let body): errorMessage = "저장 실패: \(body)"
            case .serverError(let code): errorMessage = "저장 실패 (\(code))"
            default: errorMessage = "오류: \(error)"
            }
            success = false
        } catch {
            errorMessage = "오류: \(error.localizedDescription)"
            success = false
        }
        
        isLoading = false
        return success
    }
    
    func addGalleryImage(_ image: UIImage) { galleryImages.append(image) }
    func removeGalleryImage(_ image: UIImage) { galleryImages.removeAll(where: { $0 == image }) }
}
