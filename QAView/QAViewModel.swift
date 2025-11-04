import Foundation

class QAViewModel: ObservableObject {
    // ⬇️ 참고: 'Question' is ambiguous 오류는 프로젝트 내에 'Question'이라는 이름의 타입이
    // 두 개 이상 정의되어 있을 때 발생합니다. 모델 파일을 확인하여 하나로 합치거나 이름을 변경해야 합니다.
    @Published var questions: [Question] = []
    @Published var isLoading = false
    @Published var errorMessage: String?
     
    init() {
        // [수정됨] @MainActor가 표시된 함수를 호출하려면 비동기 컨텍스트인 Task로 감싸야 합니다.
        Task {
            await fetchQuestions(keyword: "", clubId: nil, isAnsweredOnly: false, isMyQuestionsOnly: false)
        }
    }

    // MARK: - 질문 목록 가져오기 (GET /api/v1/qna/search)
    @MainActor
    func fetchQuestions(keyword: String, clubId: Int? = nil, isAnsweredOnly: Bool, isMyQuestionsOnly: Bool = false) {
        isLoading = true
        errorMessage = nil
        
        Task {
            do {
                let response = try await Network.shared.fetchQuestions(
                    keyword: keyword,
                    clubId: clubId,
                    answered: isAnsweredOnly,
                    onlyMyQuestions: isMyQuestionsOnly
                )
                self.questions = response.content
            } catch {
                if let netError = error as? NetworkError {
                    self.errorMessage = "네트워크 오류: \(netError.localizedDescription)"
                } else {
                    self.errorMessage = "알 수 없는 오류가 발생했습니다."
                }
                print("Error fetching questions: \(error)")
            }
            isLoading = false
        }
    }
}
