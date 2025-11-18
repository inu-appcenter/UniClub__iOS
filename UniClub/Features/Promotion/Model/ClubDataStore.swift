import Foundation

// MARK: - 동아리 상세 정보 모델
struct ClubDetail: Codable, Identifiable {
    let id: Int
    let name: String
    let role: String?
    let status: RecruitmentStatus
    let startTime: String
    let endTime: String
    let simpleDescription: String?
    let description: String
    var favorite: Bool
    let notice: String
    let location: String
    let presidentName: String
    let presidentPhone: String
    let youtubeLink: String
    let instagramLink: String
    let applicationFormLink: String
    let mediaList: [MediaInfo]

    enum CodingKeys: String, CodingKey {
        case id, name, role, status, startTime, endTime, simpleDescription, description, favorite, notice, location, presidentName, presidentPhone, youtubeLink, instagramLink, applicationFormLink
        case mediaList
    }
}

// MARK: - 미디어 정보 모델
struct MediaInfo: Codable, Hashable {
    let mediaLink: String
    let mediaType: String
    let main: Bool
    let updatedAt: String

    enum CodingKeys: String, CodingKey {
        case mediaLink, mediaType, main, updatedAt
    }
}

// MARK: - 모집 상태 열거형
enum RecruitmentStatus: String, Codable {
    case SCHEDULED
    case ACTIVE
    case CLOSED
    
    var title: String {
        switch self {
        case .ACTIVE: return "모집중"
        case .SCHEDULED: return "모집 예정"
        case .CLOSED: return "모집 마감"
        }
    }
}
