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

    // 학생 확인 API 호출 (수정됨)
    func verifyStudent(studentID: String, password: String, completion: @escaping (Result<VerificationResponse, Error>) -> Void) {
        let url = APIEndpoint.verifyStudent.url
        let requestBody: [String: Any] = [
            "studentId": studentID,
            "password": password
        ]
        
        request(url: url, httpMethod: "POST", body: requestBody) { result in
            switch result {
            case .success(let data):
                // ⭐️ Data를 디코딩해서 VerificationResponse로 변환
                do {
                    let response = try JSONDecoder().decode(VerificationResponse.self, from: data)
                    completion(.success(response)) //  파싱된 response 객체를 전달
                } catch {
                    completion(.failure(error)) // JSON 디코딩 실패
                }
            case .failure(let error):
                completion(.failure(error)) //  네트워크 통신 실패
            }
        }
    }

    // 회원가입 API 호출
    func register(
        studentID: String,
        name: String,
        major: String,
        password: String,
        personalInfoAgreed: Bool,
        marketingAgreed: Bool,
        completion: @escaping (Result<RegisterResponse, Error>) -> Void
    ) {
        let url = APIEndpoint.register.url
        let requestBody: [String: Any] = [
            "studentId": studentID,
            "name": name,
            "major": major,
            "password": password,
            "nickname": "닉네임_없음",
            "personalInfoCollectionAgreement": personalInfoAgreed,
            "marketingAdvertisement": marketingAgreed,
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
                    let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
                    // ⭐️ 인증 실패(401) 등 특정 HTTP 오류를 여기서 잡을 수도 있습니다.
                    //    일단은 200~299 외에는 모두 실패 처리합니다.
                    if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                         print("Server Error Response (Code: \(statusCode)): \(jsonString)")
                    }
                    let statusCodeError = NSError(domain: "HTTPError", code: statusCode, userInfo: nil)
                    completion(.failure(statusCodeError))
                    return
                }
                
                guard let data = data else {
                    let noDataError = NSError(domain: "NoDataError", code: -1, userInfo: nil)
                    completion(.failure(noDataError))
                    return
                }

                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Received JSON from server: \(jsonString)")
                }

                completion(.success(data))
            }
        }.resume()
    }
}
