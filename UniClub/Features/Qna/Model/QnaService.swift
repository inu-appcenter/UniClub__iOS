//
//  QnaService.swift
//  UniClub
//
//  Created by 제욱 on 11/8/25.
//

import Foundation

struct QnaService {
    private let client: HTTPClient
    
    init(client: HTTPClient = .shared) {
        self.client = client
    }
    
    // MARK: - Q&A 목록 조회 (GET /api/v1/qna/search)
    func fetchQuestions(
        keyword: String,
        clubId: Int?,
        answered: Bool,
        onlyMyQuestions: Bool,
        size: Int = 10
    )async throws -> QnaListResponseDTO {
        
        var queryItems: [URLQueryItem] = [
            .init(name: "keyword", value: keyword),
            .init(name: "answered", value: String(answered)),
            .init(name: "onlyMyQuestions", value: String(onlyMyQuestions)),
            .init(name: "size", value: String(size))
        ]
        
        if let id = clubId {
            queryItems.append(.init(name: "clubId", value: String(id)))
        }
        
        // ✅ 여기서는 더 이상 URLComponents, URLSession 직접 안 씀
        return try await client.get(
            AppConfig.API.Qna.search,
            query: queryItems,
            as: QnaListResponseDTO.self
        )
    }
    func fetchQuestionDetail(id: Int) async throws -> QuestionDetail {
        try await client.get(
            AppConfig.API.Qna.detail(id),
            as: QuestionDetail.self
        )
    }
    
    func createQuestion(_ body: NewQuestionRequest) async throws {
        // POST /api/v1/qna
    }
    
    func createAnswer(questionId: Int, body: NewAnswerRequest) async throws {
        // POST /api/v1/qna/{id}/answers
    }
    
    // MARK: - 동아리 검색 (GET /api/v1/qna/search-clubs)
    func searchClubs(keyword: String) async throws -> [QnaSearchClubDTO] {
        // ✅ 공백 입력 처리
        let safeKeyword = keyword.trimmingCharacters(in: .whitespaces)
        
        // ✅ 쿼리 아이템 구성
        let queryItems: [URLQueryItem] = [
            .init(name: "keyword", value: safeKeyword.isEmpty ? nil : safeKeyword)
        ]
        
        // ✅ 실제 요청 (fetchQuestions() 형식과 동일)
        return try await client.get(
            AppConfig.API.Qna.searchclubs,
            query: queryItems,                       // ✅ 여기 label 추가!
            as: [QnaSearchClubDTO].self
        )
    }
}
