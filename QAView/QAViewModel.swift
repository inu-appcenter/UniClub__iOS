import Foundation
import Combine

class QAViewModel: ObservableObject {
    @Published var questions: [Question] = []
    @Published var isLoading = false
    
    private var cancellables = Set<AnyCancellable>()
    
    private let baseURL = "https://uniclub-server.inuappcenter.kr/api/v1/qna"

    // 질문 목록 가져오기 (GET /search)
    func fetchQuestions(keyword: String, isAnsweredOnly: Bool) {
        guard var urlComponents = URLComponents(string: "\(baseURL)/search") else { return }
        
        var queryItems: [URLQueryItem] = []
        if !keyword.isEmpty {
            queryItems.append(URLQueryItem(name: "keyword", value: keyword))
        }
        queryItems.append(URLQueryItem(name: "isAnswered", value: String(isAnsweredOnly)))
        // TODO: 동아리 선택 필터가 있다면 쿼리 아이템 추가
        
        urlComponents.queryItems = queryItems
        guard let url = urlComponents.url else { return }
        
        isLoading = true
        
        URLSession.shared.dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: [Question].self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    print("Error fetching questions: \(error.localizedDescription)")
                }
            } receiveValue: { [weak self] fetchedQuestions in
                self?.questions = fetchedQuestions
            }
            .store(in: &cancellables)
    }
    
    // 새로운 질문 등록하기 (POST /)
    func postQuestion(clubId: Int, content: String, isAnonymous: Bool, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: baseURL) else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        // TODO: 인증 토큰이 필요하다면 헤더에 추가
        
        let requestBody = NewQuestionRequest(clubId: clubId, content: content, isAnonymous: isAnonymous)
        
        do {
            request.httpBody = try JSONEncoder().encode(requestBody)
        } catch {
            print("Error encoding question: \(error)")
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode), error == nil else {
                DispatchQueue.main.async { completion(false) }
                return
            }
            // 질문 등록 성공 후 목록을 새로고침
            DispatchQueue.main.async {
                self.fetchQuestions(keyword: "", isAnsweredOnly: false)
                completion(true)
            }
        }.resume()
    }
}
