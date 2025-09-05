import Foundation
import Combine

class QnaDetailViewModel: ObservableObject {
    @Published var questionDetail: QuestionDetail?
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    private let baseURL = "https://uniclub-server.inuappcenter.kr/api/v1/qna"

    // 특정 질문 및 답변 목록 불러오기 (GET /{questionId})
    func fetchQuestionDetail(questionId: Int) {
        guard let url = URL(string: "\(baseURL)/\(questionId)") else { return }
        
        isLoading = true
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: QuestionDetail.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("Error fetching question detail: \(error.localizedDescription)")
                    // TODO: 사용자에게 에러 알림 표시
                }
            } receiveValue: { [weak self] detail in
                self?.questionDetail = detail
            }
            .store(in: &cancellables)
    }
    
    // 새로운 답변 등록하기 (POST /{questionId}/answers)
    func postAnswer(questionId: Int, content: String, isAnonymous: Bool, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "\(baseURL)/\(questionId)/answers") else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // TODO: 인증 토큰이 필요하다면 헤더에 추가
        
        let requestBody = NewAnswerRequest(content: content, isAnonymous: isAnonymous)
        
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            print("Error encoding answer: \(error)")
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse,
                  (200...299).contains(httpResponse.statusCode),
                  error == nil else {
                print("Error posting answer: \(error?.localizedDescription ?? "Unknown error")")
                DispatchQueue.main.async { completion(false) }
                return
            }
            DispatchQueue.main.async { completion(true) }
        }.resume()
    }
}
