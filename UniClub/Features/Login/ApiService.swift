import Foundation

// MARK: - API 엔드포인트

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

// MARK: - 에러 정의 (AuthError)
enum AuthError: Error {
    case userAlreadyExists
    case serverError(statusCode: Int)
    case noData
    case decodingError
}

// MARK: - 응답 데이터 모델 (Structs)

struct LoginResponse: Codable {
    let accessToken: String
    let refreshToken: String
    let message: String?
}

struct RegisterResponse: Codable {
    let message: String?
}

// ⚠️ 중요: 'VerificationResponse'가 이미 다른 파일(예: Models.swift)이나
// 프로젝트 어딘가에 정의되어 있어서 오류가 난 것입니다.
// 따라서 여기서는 정의를 지우고, 기존에 있는 것을 사용하도록 합니다.
// 만약 "Cannot find type 'VerificationResponse' in scope" 오류가 나면 아래 주석을 해제하세요.

/*
struct VerificationResponse: Codable {
    let verification: Bool
}
*/

// MARK: - API Service

class APIService {
    
    static let shared = APIService()
    
    private init() {}
    
    // 1. 로그인 API
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
                    print("Decoding Error: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 2. 학생 확인 API
    // ⚠️ 여기서 VerificationResponse 타입을 사용합니다. (프로젝트 내 어딘가에 정의된 것을 참조)
    func verifyStudent(studentID: String, password: String, completion: @escaping (Result<VerificationResponse, Error>) -> Void) {
        let url = APIEndpoint.verifyStudent.url
        let requestBody: [String: Any] = [
            "studentId": studentID,
            "password": password
        ]
        
        request(url: url, httpMethod: "POST", body: requestBody) { result in
            switch result {
            case .success(let data):
                do {
                    // 데이터 파싱
                    let response = try JSONDecoder().decode(VerificationResponse.self, from: data)
                    completion(.success(response))
                } catch {
                    print("Decoding Error: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 3. 회원가입 API
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
            "nickname": "닉네임_없음", // 닉네임 기본값 처리
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
                    print("Decoding Error: \(error)")
                    completion(.failure(error))
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    // 4. 범용 요청 함수
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
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let error = error {
                DispatchQueue.main.async { completion(.failure(error)) }
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                DispatchQueue.main.async { completion(.failure(AuthError.serverError(statusCode: 0))) }
                return
            }
            
            // 상태 코드 확인 (200~299 성공)
            if (200...299).contains(httpResponse.statusCode) {
                guard let data = data else {
                    DispatchQueue.main.async { completion(.failure(AuthError.noData)) }
                    return
                }
                DispatchQueue.main.async { completion(.success(data)) }
                
            } else {
                // 에러 로그
                if let data = data, let jsonString = String(data: data, encoding: .utf8) {
                    print("Server Error (Code: \(httpResponse.statusCode)): \(jsonString)")
                }
                
                DispatchQueue.main.async {
                    if httpResponse.statusCode == 409 {
                        completion(.failure(AuthError.userAlreadyExists))
                    } else {
                        completion(.failure(AuthError.serverError(statusCode: httpResponse.statusCode)))
                    }
                }
            }
        }
        
        task.resume()
    }
}
