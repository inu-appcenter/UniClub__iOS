//
//  DTOUtil.swift
//  UniClub
//
//  Created by 제욱 on 8/31/25.
//

import Foundation

// Banner
struct MainBannerDTO: Decodable {
    let mediaLink: String
    let mediaType: String?
}

// Clubs (메인 섹션)
struct MainClubDTO: Decodable {
    let name: String
    let imageUrl: String?
    let favorite: Bool?
}


extension String {
    func asAbsoluteURL(base: URL) -> URL? {
        if let u = URL(string: self), u.scheme != nil { return u }
        return URL(string: base.absoluteString + (hasPrefix("/") ? self : "/"+self))
    }
}

// DTOUtil.swift (기존 파일 맨 아래에 추가)
// 서버 category 값과 1:1 매핑
enum ClubCategory: String, Codable, CaseIterable, Sendable {
    case liberalAcademic = "LIBERAL_ACADEMIC"  // 교양학술
    case hobbyExhibition = "HOBBY_EXHIBITION"  // 취미전시
    case sports          = "SPORTS"            // 체육
    case religion        = "RELIGION"          // 종교
    case volunteer       = "VOLUNTEER"         // 봉사
    case culture         = "CULTURE"           // 문화

    var displayName: String {
        switch self {
        case .liberalAcademic: return "교양·학술"
        case .hobbyExhibition: return "취미·전시"
        case .sports:          return "체육"
        case .religion:        return "종교"
        case .volunteer:       return "봉사"
        case .culture:         return "문화"
        }
    }
}

struct ClubListResponse: Decodable {
    let content: [ClubListItem]
    let hasNext: Bool
}

struct ClubListItem: Decodable, Identifiable, Sendable, Equatable {
    let id: Int
    let name: String
    let info: String?
    let status: String?
    let favorite: Bool?
    let category: ClubCategory
    let clubProfileUrl: String?

    var profileURL: URL? {
        guard let clubProfileUrl, !clubProfileUrl.isEmpty else { return nil }
        // 이미 쓰는 유틸 재사용: 상대경로 → 절대 URL
        return clubProfileUrl.asAbsoluteURL(base: AppConfig.baseURL)
    }
}

extension ClubCategory: Hashable {}

extension ClubCategory {
    /// 카테고리 한글 라벨 → Enum
    init?(displayName: String) {
        switch displayName {
        case "교양학술": self = .liberalAcademic
        case "취미전시": self = .hobbyExhibition
        case "체육":     self = .sports
        case "종교":     self = .religion
        case "봉사":     self = .volunteer
        case "문화":     self = .culture
        default: return nil
        }
    }
    
}

struct UserProfileDTO: Decodable, Equatable {
    let nickname: String?
    let name: String
    let studentId: String?           // 예: "23학번"
    let major: String?
    let profileImageLink: String?
}

extension UserProfileDTO {
    var profileURL: URL? {
        guard let link = profileImageLink, let url = URL(string: link) else { return nil }
        return url
    }
}

/// Q&A 목록 API 응답 전체를 나타내는 DTO
/// GET /api/v1/qna/search 의 응답 형식
struct QnaListResponseDTO: Decodable {
    let content: [QnaListItemDTO]
    let hasNext: Bool
}

/// Q&A 목록에 표시되는 각 질문 요약 정보
struct QnaListItemDTO: Decodable, Identifiable {
    let questionId: Int
    let nickname: String
    let clubName: String?
    let content: String
    let countAnswer: Int
    
    // SwiftUI ForEach에서 쓰기 편하게 Identifiable 채택
    var id: Int { questionId }
}


/// Q&A - 동아리 검색용 DTO
struct QnaSearchClubDTO: Decodable, Identifiable {
    let clubId: Int
    let clubName: String
    let categoryType: String
    
    // ForEach에서 쓰기 편하게
    var id: Int { clubId }
}
