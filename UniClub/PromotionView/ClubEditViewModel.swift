import SwiftUI
import UIKit

@MainActor
class ClubEditViewModel: ObservableObject {
    
    // (프로퍼티 선언부는 이전과 동일)
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
    @Published var startTime: String = ""
    @Published var endTime: String = ""
    @Published var startDate: Date = Date()
    @Published var endDate: Date = Date()
    @Published var bannerImage: UIImage?
    @Published var profileImage: UIImage?
    @Published var galleryImages: [UIImage] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
    private var clubId: Int?
    
    private let serverDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
    // (fetchData 함수는 이전과 동일)
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

            self.startDate = serverDateFormatter.date(from: clubDetail.startTime) ?? Date()
            self.endDate = serverDateFormatter.date(from: clubDetail.endTime) ?? Date()
            
            self.startTime = clubDetail.startTime
            self.endTime = clubDetail.endTime
            
            self.bannerImage = nil
            self.profileImage = nil
            self.galleryImages = []
            
        } catch {
            self.errorMessage = "데이터를 불러오지 못했습니다: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    // MARK: - ⭐️ 수정됨: catch 블록
    func saveChanges() async -> Bool {
        guard let clubId = clubId else {
            errorMessage = "동아리 ID가 없습니다."
            return false
        }
        isLoading = true
        errorMessage = nil
        
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
            success = try await NetworkGateway.updateClubDetail(
                clubId: clubId,
                clubData: updatedData
            )
        }
        // ⭐️ 수정됨: 자세한 오류를 잡도록 catch 블록 분리
        catch let error as GatewayFault {
            switch error {
            case .serverErrorWithBody(let code, let body):
                errorMessage = "저장 실패 [\(code)]\n\(body)"
            case .serverError(let code):
                errorMessage = "저장 실패 [\(code)]"
            case .networkError(let netError):
                errorMessage = "네트워크 오류: \(netError.localizedDescription)"
            case .decodingError:
                errorMessage = "응답 디코딩 오류"
            default:
                errorMessage = "알 수 없는 게이트웨이 오류"
            }
            success = false
        } catch {
            errorMessage = "알 수 없는 오류: \(error.localizedDescription)"
            success = false
        }
        
        isLoading = false
        if !success && errorMessage == nil {
            // 이 코드는 'true'를 반환받았는데도 실패한 경우 (로직상 거의 불가능)
            errorMessage = "저장에 실패했습니다."
        }
        return success
    }
    
    // (이미지 추가/삭제 헬퍼 함수는 동일)
    func addGalleryImage(_ image: UIImage) {
        galleryImages.append(image)
    }
    
    func removeGalleryImage(_ image: UIImage) {
        galleryImages.removeAll(where: { $0 == image })
    }
}
