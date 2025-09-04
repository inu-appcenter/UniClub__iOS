import Foundation

// MARK: - 로그인 및 회원가입 관련 모델
// 회원가입 요청을 위한 데이터 구조체
struct SignupRequest: Codable {
    let studentId: String
    let password: String
    let name: String
    let major: String
    var personalInfoCollectionAgreement: Bool
    var marketingAdvertisement: Bool
    let studentVerification: Bool
}

// 재학생 인증 요청을 위한 데이터 구조체
struct StudentVerificationRequest: Codable {
    let studentId: String
    let password: String
}

// API 통신 시 발생할 수 있는 에러 정의
enum APIError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case serverError(statusCode: Int)
    case decodingError(Error)
    case encodingError(Error)
    case networkError(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "유효하지 않은 URL입니다."
        case .invalidResponse:
            return "유효하지 않은 응답입니다."
        case .serverError(let statusCode):
            return "서버 오류가 발생했습니다. 상태 코드: \(statusCode)"
        case .decodingError(let error):
            return "데이터 디코딩 오류: \(error.localizedDescription)"
        case .encodingError(let error):
            return "데이터 인코딩 오류: \(error.localizedDescription)"
        case .networkError(let error):
            return "네트워크 오류: \(error.localizedDescription)"
        }
    }
}


// MARK: - 동아리 관련 모델
enum RecruitmentStatus: String, Codable, CaseIterable {
    case recruiting = "모집 중"
    case scheduled = "모집 예정"
    case closed = "모집 마감"
    
    mutating func next() {
        switch self {
        case .recruiting:
            self = .scheduled
        case .scheduled:
            self = .closed
        case .closed:
            self = .recruiting
        }
    }
}

// Club 데이터 모델
struct Club: Codable, Identifiable {
    var id: UUID = UUID()
    let name: String
    let status: String
    let startTime: String
    let endTime: String
    let description: String
    let notice: String
    let location: String
    let presidentName: String
    let presidentPhone: String
    let youtubeLink: String?
    let instagramLink: String?
    let profileImage: String
    let backgroundImage: String
    let mediaLinks: [String]
    
    enum CodingKeys: String, CodingKey {
        case name, status, startTime, endTime, description, notice, location, presidentName, presidentPhone, youtubeLink, instagramLink, profileImage, backgroundImage, mediaLinks
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.name = (try? container.decode(String.self, forKey: .name)) ?? ""
        self.status = (try? container.decode(String.self, forKey: .status)) ?? ""
        self.startTime = (try? container.decode(String.self, forKey: .startTime)) ?? ""
        self.endTime = (try? container.decode(String.self, forKey: .endTime)) ?? ""
        self.description = (try? container.decode(String.self, forKey: .description)) ?? ""
        self.notice = (try? container.decode(String.self, forKey: .notice)) ?? ""
        self.location = (try? container.decode(String.self, forKey: .location)) ?? ""
        self.presidentName = (try? container.decode(String.self, forKey: .presidentName)) ?? ""
        self.presidentPhone = (try? container.decode(String.self, forKey: .presidentPhone)) ?? ""
        self.youtubeLink = try? container.decode(String.self, forKey: .youtubeLink)
        self.instagramLink = try? container.decode(String.self, forKey: .instagramLink)
        self.profileImage = (try? container.decode(String.self, forKey: .profileImage)) ?? ""
        self.backgroundImage = (try? container.decode(String.self, forKey: .backgroundImage)) ?? ""
        self.mediaLinks = (try? container.decode([String].self, forKey: .mediaLinks)) ?? []
    }
    
    init(name: String, status: String, startTime: String, endTime: String, description: String, notice: String, location: String, presidentName: String, presidentPhone: String, youtubeLink: String?, instagramLink: String?, profileImage: String, backgroundImage: String, mediaLinks: [String]) {
        self.name = name
        self.status = status
        self.startTime = startTime
        self.endTime = endTime
        self.description = description
        self.notice = notice
        self.location = location
        self.presidentName = presidentName
        self.presidentPhone = presidentPhone
        self.youtubeLink = youtubeLink
        self.instagramLink = instagramLink
        self.profileImage = profileImage
        self.backgroundImage = backgroundImage
        self.mediaLinks = mediaLinks
    }
}
