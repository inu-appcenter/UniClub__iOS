import Foundation

// MARK: - Q&A List Models

// 목록에 표시될 간단한 질문 모델
struct Question: Codable, Identifiable {
    let id: Int
    let authorName: String
    let createdAt: String
    let clubName: String?
    let content: String
    let isAnswered: Bool
}

// 새로운 질문 등록 요청 모델
struct NewQuestionRequest: Codable {
    let clubId: Int
    let content: String
    let isAnonymous: Bool
}


// MARK: - Q&A Detail Models

// 답변 모델
struct Answer: Codable, Identifiable {
    let id: Int
    let authorName: String
    let createdAt: String
    let content: String
    // 'isVerified'는 API 응답에 따라 추가/수정될 수 있습니다.
    // let isVerified: Bool?
}

// 질문 상세 정보 모델 (질문 + 답변 목록)
struct QuestionDetail: Codable {
    let id: Int
    let authorName: String
    let createdAt: String
    let clubName: String?
    let content: String
    let answers: [Answer]
}

// 새로운 답변 등록 요청 모델
struct NewAnswerRequest: Codable {
    let content: String
    let isAnonymous: Bool
}
