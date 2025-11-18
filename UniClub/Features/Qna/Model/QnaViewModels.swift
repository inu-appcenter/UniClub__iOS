//
//  QnaViewModels.swift
//  UniClub
//
//  Created by 제욱 on 11/11/25.
//

import Foundation

@MainActor
final class QnaViewModel: ObservableObject {
    @Published var questions: [QnaListItemDTO] = []
    @Published var questionDetail: QuestionDetail?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let service = QnaService()
    
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

final class SearchClubViewModel: ObservableObject {
    @Published var isLoading = false
    @Published var errorMessage: String?
    @Published var clubs: [ClubInfo] = []
    
    private let service = QnaService()
    
    @MainActor
    func search(keyword: String) {
        Task {
            isLoading = true
            errorMessage = nil
            do {
                let dtoList = try await service.searchClubs(keyword: keyword)
                self.clubs = dtoList.map {
                    ClubInfo(
                        id: $0.clubId,
                        name: $0.clubName,
                        category: $0.categoryType
                    )
                }
            } catch let apiError as APIError {
                self.errorMessage = apiError.errorDescription ?? "동아리 목록을 불러오지 못했습니다."
            } catch {
                self.errorMessage = "동아리 목록을 불러오지 못했습니다."
            }
            isLoading = false
        }
    }
}
