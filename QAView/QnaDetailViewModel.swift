import Foundation

class QnaDetailViewModel: ObservableObject {
    @Published var questionDetail: QuestionDetail?
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    // MARK: - 질문 상세 정보 가져오기 (GET /api/v1/qna/{questionId})
    @MainActor
    func fetchQuestionDetail(questionId: Int) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                // Network.shared를 통해 API 호출
                let detail = try await Network.shared.fetchQuestionDetail(questionId: questionId)
                self.questionDetail = detail
            } catch {
                if let netError = error as? NetworkError {
                    self.errorMessage = "네트워크 오류: \(netError)"
                } else {
                    self.errorMessage = "알 수 없는 오류가 발생했습니다."
                }
                print("Error fetching question detail: \(error)")
            }
            isLoading = false
        }
    }
    
}
