import Foundation

// API 서비스의 엔드포인트를 정의하는 열거형
enum APIEndpoint {
    case login
    case verifyStudent
    case register
    
    var url: URL {
        // 실제 API 서버의 URL을 여기에 입력하세요.
        let baseURL = "https://uniclub-server.inuappcenter.kr"
        
        switch self {
        case .login:
            return URL(string: baseURL + "login")!
        case .verifyStudent:
            return URL(string: baseURL + "verifyStudent")!
        case .register:
            return URL(string: baseURL + "register")!
        }
    }
}

class ApiService {
    
    static let shared = ApiService()
    
    private init() {}
    
    // 로그인 API 호출 함수
    func login(studentID: String, password: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let url = APIEndpoint.login.url
        let requestBody: [String: String] = [
            "studentID": studentID,
            "password": password
        ]
        request(url: url, httpMethod: "POST", body: requestBody, completion: completion)
    }

    // 학생 확인 API 호출 함수
    func verifyStudent(studentID: String, password: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let url = APIEndpoint.verifyStudent.url
        let requestBody: [String: String] = [
            "studentID": studentID,
            "password": password
        ]
        request(url: url, httpMethod: "POST", body: requestBody, completion: completion)
    }

    // 회원가입 API 호출 함수
    func register(studentID: String, password: String, name: String, major: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let url = APIEndpoint.register.url
        let requestBody: [String: String] = [
            "studentID": studentID,
            "password": password,
            "name": name,
            "major": major
        ]
        request(url: url, httpMethod: "POST", body: requestBody, completion: completion)
    }
    
    // API 요청을 처리하는 제네릭 함수
    private func request(url: URL, httpMethod: String, body: [String: String], completion: @escaping (Result<Data, Error>) -> Void) {
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])
        } catch {
            completion(.failure(error))
            return
        }
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let error = error {
                    completion(.failure(error))
                    return
                }
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    let statusCodeError = NSError(domain: "HTTPError", code: (response as? HTTPURLResponse)?.statusCode ?? -1, userInfo: nil)
                    completion(.failure(statusCodeError))
                    return
                }
                
                guard let data = data else {
                    let noDataError = NSError(domain: "NoDataError", code: -1, userInfo: nil)
                    completion(.failure(noDataError))
                    return
                }
                
                completion(.success(data))
            }
        }.resume()
    }
}
