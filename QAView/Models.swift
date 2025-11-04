import Foundation

// MARK: - Base URL
// 모든 API 요청에 사용될 기본 URL
struct APIConstants {
    static let baseURL = URL(string: "https://uniclub-server.inuappcenter.kr")!
}

// MARK: - Question List (GET /api/v1/qna/search)
// 질문 목록 API의 개별 질문 응답 구조
struct Question: Identifiable, Codable {
    // API 명세서에 맞춰 UUID 대신 Int 타입 사용
    var id: Int { questionId }
    let questionId: Int
    let nickname: String
    let clubName: String?
    let content: String
    let countAnswer: Int // 답변 개수
    
    // UI 표시를 위해 임의로 추가 (ViewModel에서 변환 필요)
    var authorName: String { nickname }
    var createdAt: String { "" } // API 응답에 생성 시간 필드가 없어 임시 처리
}

// 질문 목록 API의 전체 응답 구조
struct QuestionListResponse: Codable {
    let content: [Question]
    let hasNext: Bool
}

// MARK: - Question Detail (GET /api/v1/qna/{questionId})
// 질문 상세 API의 답변 응답 구조
struct Answer: Identifiable, Codable {
    var id: Int { answerId } // Identifiable 요구사항 충족
    let answerId: Int
    let nickname: String
    let content: String
    let anonymous: Bool
    let deleted: Bool
    let updateTime: String? // 날짜 형식: 2025-08-25T11:00:00
    let parentAnswerId: Int?
    let owner: Bool // 본인이 작성한 답변인지 여부
    
    var authorName: String { nickname } // UI 호환성을 위해 추가
    var createdAt: String { updateTime ?? "" } // UI 호환성을 위해 추가
}

// 질문 상세 API의 전체 응답 구조
struct QuestionDetail: Identifiable, Codable {
    var id: Int { questionId } // Identifiable 요구사항 충족
    let questionId: Int
    let nickname: String
    let content: String
    let anonymous: Bool
    let answered: Bool
    let updatedAt: String // 날짜 형식: 2025-08-25T10:30:00
    let answers: [Answer]
    let owner: Bool // 질문 작성자 본인 여부
    let president: Bool // 동아리 회장 여부
    
    var authorName: String { nickname } // UI 호환성을 위해 추가
    var clubName: String? // API 응답에 clubName 필드가 없어 임시 처리
}

// MARK: - Request Models
// 1. 질문 등록 (POST /api/v1/qna)
struct NewQuestionRequest: Codable {
    let content: String
    let anonymous: Bool
}

// 2. 질문 수정 (PATCH /api/v1/qna/{questionId})
struct EditQuestionRequest: Codable {
    let content: String
    let anonymous: Bool
    let answered: Bool? // PATCH 요청에 포함될 수 있음 (응답 예시에는 있었으나, 질문 수정 API에서는 answered 상태 변경은 다른 엔드포인트에서 관리하는 것이 일반적이므로 옵셔널로 처리)
}

// 3. 답변/댓글 등록 (POST /api/v1/qna/{questionId}/answers)
struct NewAnswerRequest: Codable {
    let content: String
    let anonymous: Bool
}
