import Foundation

// API 서비스의 엔드포인트를 정의하는 열거형
enum APIEndpoint {
    static let baseURL = URL(string: "https://uniclub-server.inuappcenter.kr")!
    
    case login
    case verifyStudent
    case register
    
    var url: URL {
        switch self {
        case .login:
            return APIEndpoint.baseURL.appendingPathComponent("/api/v1/auth/login")
        case .verifyStudent:
            return APIEndpoint.baseURL.appendingPathComponent("/api/v1/auth/register/student-verification")
        case .register:
            return APIEndpoint.baseURL.appendingPathComponent("/api/v1/auth/register")
        }
    }
}

// API 응답 구조체들
struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let message: String?
}

struct RegisterResponse: Codable {
    let message: String?
}

// MARK: - API Service (with debugging)
class APIService {
    
    static let shared = APIService()
    
    private init() {}
    
    // 로그인 API 호출
    func login(studentID: String, password: String, completion: @escaping (Result<LoginResponse, Error>) -> Void) {
        let url = APIEndpoint.login.url
        let requestBody: [String: Any] = [
            "studentId": studentID,
            "password": password
        ]
        
        request(url: url, httpMethod: "POST", body: requestBody) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(LoginResponse.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // 학생 확인 API 호출
    func verifyStudent(studentID: String, password: String, completion: @escaping (Result<Data, Error>) -> Void) {
        let url = APIEndpoint.verifyStudent.url
        let requestBody: [String: Any] = [
            "studentId": studentID,
            "password": password
        ]
        
        request(url: url, httpMethod: "POST", body: requestBody) { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }

    // 회원가입 API 호출
    func register(studentID: String, name: String, major: String, password: String, completion: @escaping (Result<RegisterResponse, Error>) -> Void) {
        let url = APIEndpoint.register.url
        let requestBody: [String: Any] = [
            "studentId": studentID,
            "name": name,
            "major": major,
            "password": password,
            "nickname": "닉네임_없음",
            "personalInfoCollectionAgreement": true,
            "marketingAdvertisement": false,
            "studentVerification": true
        ]
        
        request(url: url, httpMethod: "POST", body: requestBody) { result in
            switch result {
            case .success(let data):
                do {
                    let response = try JSONDecoder().decode(RegisterResponse.self, from: data)
                    completion(.success(response))
                } catch {
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 범용 API 요청 함수
    private func request(url: URL, httpMethod: String, body: [String: Any], completion: @escaping (Result<Data, Error>) -> Void) {
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

                // MARK: - 서버 응답 디버깅 코드 추가
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Received JSON from server: \(jsonString)")
                }
                // MARK: -

                completion(.success(data))
            }
        }.resume()
    }
}
