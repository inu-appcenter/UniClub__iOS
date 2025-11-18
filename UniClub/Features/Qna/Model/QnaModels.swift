//
//  QnaModels.swift
//  UniClub
//
//  Created by 제욱 on 11/11/25.
//

import Foundation

// MARK: - DTO / Request Models
struct Answer: Identifiable, Codable {
    var id: Int { answerId }
    let answerId: Int
    let nickname: String
    let content: String
    let anonymous: Bool
    let deleted: Bool
    let updateTime: String?
    let parentAnswerId: Int?
    let owner: Bool

    var authorName: String { nickname }
    var createdAt: String { updateTime ?? "" }
}

struct QuestionDetail: Identifiable, Codable {
    var id: Int { questionId }
    let questionId: Int
    let nickname: String
    let content: String
    let anonymous: Bool
    let answered: Bool
    let updatedAt: String
    let answers: [Answer]
    let owner: Bool
    let president: Bool

    var authorName: String { nickname }
    var clubName: String?
}

struct NewQuestionRequest: Codable {
    let content: String
    let anonymous: Bool
}

struct EditQuestionRequest: Codable {
    let content: String
    let anonymous: Bool
    let answered: Bool?
}

struct NewAnswerRequest: Codable {
    let content: String
    let anonymous: Bool
}

// MARK: - Service Layer
struct QnaService {
    private let client: HTTPClient
    
    init(client: HTTPClient = .shared) {
        self.client = client
    }
    
    func fetchQuestions(
        keyword: String,
        clubId: Int?,
        answered: Bool,
        onlyMyQuestions: Bool,
        size: Int = 10
    ) async throws -> QnaListResponseDTO {
        var queryItems: [URLQueryItem] = [
            .init(name: "keyword", value: keyword),
            .init(name: "answered", value: String(answered)),
            .init(name: "onlyMyQuestions", value: String(onlyMyQuestions)),
            .init(name: "size", value: String(size))
        ]
        
        if let id = clubId {
            queryItems.append(.init(name: "clubId", value: String(id)))
        }
        
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
    
    func createQuestion(_ body: NewQuestionRequest) async throws {}
    
    func createAnswer(questionId: Int, body: NewAnswerRequest) async throws {}
    
    func searchClubs(keyword: String) async throws -> [QnaSearchClubDTO] {
        let safeKeyword = keyword.trimmingCharacters(in: .whitespaces)
        let queryItems: [URLQueryItem] = [
            .init(name: "keyword", value: safeKeyword.isEmpty ? nil : safeKeyword)
        ]
        return try await client.get(
            AppConfig.API.Qna.searchclubs,
            query: queryItems,
            as: [QnaSearchClubDTO].self
        )
    }
}
