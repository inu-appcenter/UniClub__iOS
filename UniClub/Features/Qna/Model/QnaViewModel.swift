//
//  QnaViewModel.swift
//  UniClub
//
//  Created by 제욱 on 11/8/25.
//

import Foundation

@MainActor
final class QnaViewModel: ObservableObject {
    @Published var questions: [QnaListItemDTO] = []
    @Published var questionDetail: QuestionDetail?
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?
    
    private let service = QnaService()
    
    // MARK: - 목록 조회
    func fetchQuestions(
        keyword: String,
        clubId: Int? = nil,
        isAnsweredOnly: Bool,
        isMyQuestionsOnly: Bool = false
    ) {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                let res = try await service.fetchQuestions(
                    keyword: keyword,
                    clubId: clubId,
                    answered: isAnsweredOnly,
                    onlyMyQuestions: isMyQuestionsOnly
                )
                self.questions = res.content
            } catch {
                self.errorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }
    
    // MARK: - 상세 조회
    func fetchQuestionDetail(id: Int) {
        isLoading = true
        errorMessage = nil
        Task {
            do {
                let detail = try await service.fetchQuestionDetail(id: id)
                self.questionDetail = detail
            } catch {
                self.errorMessage = error.localizedDescription
            }
            self.isLoading = false
        }
    }
}
