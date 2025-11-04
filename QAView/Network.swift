import Foundation

// MARK: - Network Error
enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingError(Error)
    case apiError(code: Int, message: String)
    case unknown
}

// MARK: - Network
class Network {
    
    static let shared = Network()
    
    // MARK: - 1. 질문 목록 조회 (GET /api/v1/qna/search)
    func fetchQuestions(
        keyword: String,
        clubId: Int?,
        answered: Bool,
        onlyMyQuestions: Bool,
        size: Int = 10
    ) async throws -> QuestionListResponse {
        
        var urlComponents = URLComponents(url: APIConstants.baseURL.appendingPathComponent("api/v1/qna/search"), resolvingAgainstBaseURL: true)!
        
        var queryItems: [URLQueryItem] = [
            URLQueryItem(name: "keyword", value: keyword),
            URLQueryItem(name: "answered", value: String(answered)),
            URLQueryItem(name: "onlyMyQuestions", value: String(onlyMyQuestions)),
            URLQueryItem(name: "size", value: String(size))
        ]
        
        if let id = clubId {
            queryItems.append(URLQueryItem(name: "clubId", value: String(id)))
        }
        
        urlComponents.queryItems = queryItems
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(QuestionListResponse.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
     
    // MARK: - 2. 특정 질문 상세 조회 (GET /api/v1/qna/{questionId})
    func fetchQuestionDetail(questionId: Int) async throws -> QuestionDetail {
        let path = "api/v1/qna/\(questionId)"
        
        // [수정됨] URL에 경로를 추가할 때는 'appendingPathComponent'를 사용해야 합니다.
        let url = APIConstants.baseURL.appendingPathComponent(path)

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        do {
            let decodedResponse = try JSONDecoder().decode(QuestionDetail.self, from: data)
            return decodedResponse
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
}
