import Foundation

// 1. 커스텀 에러 정의
enum APIServiceError: Error {
    case invalidURL
    case invalidResponse
    case requestFailed(statusCode: Int)
    case decodingError(Error)
}

// 2. API 통신을 전담하는 서비스 클래스
@MainActor
class NotificationService {

    private let baseURL = URL(string: "https://uniclub-server.inuappcenter.kr/api/v1")!

    // 1️⃣ 알림 목록 조회 (GET /notifications) - ⭐️ 디코딩 로직 수정 ⭐️
    func fetchNotifications(page: Int = 0, size: Int = 20) async throws -> [AppNotification] {

        var components = URLComponents(url: baseURL.appendingPathComponent("/notifications"), resolvingAgainstBaseURL: true)!
        components.queryItems = [
            URLQueryItem(name: "page", value: "\(page)"),
            URLQueryItem(name: "size", value: "\(size)"),
            URLQueryItem(name: "sort", value: "createdAt,DESC")
        ]

        guard let url = components.url else { throw APIServiceError.invalidURL }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        guard let token = TokenManager.shared.getToken() else {
             print("--- [API Error] ---")
             print("Error: TokenManager.shared.getToken() is nil. (토큰 없음)")
             throw APIServiceError.requestFailed(statusCode: 401)
        }

        print("--- [API Request] ---")
        print("URL: \(url.absoluteString)")
        print("Token being sent: Bearer \(token)")
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")


        let (data, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse else {
            print("--- [API Error] ---")
            print("Error: Not an HTTP response")
            throw APIServiceError.invalidResponse
        }

        print("--- [API Response] ---")
        print("Status Code: \(httpResponse.statusCode)")

        guard (200...299).contains(httpResponse.statusCode) else {
            let errorBody = String(data: data, encoding: .utf8) ?? "No response body"
            print("Error Body: \(errorBody)")
            throw APIServiceError.requestFailed(statusCode: httpResponse.statusCode)
        }

        // ⭐️ 디코딩 오류 확인
        do {
            // ⭐️⭐️⭐️ 수정된 부분 ⭐️⭐️⭐️
            // NotificationResponse.self (객체)를 디코딩
            let pagedResponse = try JSONDecoder().decode(NotificationResponse.self, from: data)

            // ⭐️ pagedResponse.notifications (배열)를 반환
            print("Success: Decoding complete. \(pagedResponse.notifications.count) items fetched.")
            return pagedResponse.notifications
            // ⭐️⭐️⭐️ (여기까지) ⭐️⭐️⭐️

        } catch let decodingError {
            print("--- [Decoding Error] ---")
            print("Error: \(decodingError)")
            let dataString = String(data: data, encoding: .utf8) ?? "Data was not valid UTF-8"
            print("Data that failed to decode: \n\(dataString)")
            throw APIServiceError.decodingError(decodingError)
        }
    }

    // (이하 다른 함수들은 변경 없음)

    // 2️⃣ 개별 알림 읽음 처리
    func markAsRead(id: Int) async throws {
        let url = baseURL.appendingPathComponent("/notifications/\(id)/read")
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"

        guard let token = TokenManager.shared.getToken() else {
            throw APIServiceError.requestFailed(statusCode: 401)
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIServiceError.requestFailed(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 500)
        }
    }

    // 3️⃣ 모든 알림 읽음 처리
    func markAllAsRead() async throws {
        let url = baseURL.appendingPathComponent("/notifications/read-all")
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"

        guard let token = TokenManager.shared.getToken() else {
            throw APIServiceError.requestFailed(statusCode: 401)
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIServiceError.requestFailed(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 500)
        }
    }

    // 4️⃣ 개별 알림 삭제
    func deleteNotification(id: Int) async throws {
        let url = baseURL.appendingPathComponent("/notifications/\(id)")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        guard let token = TokenManager.shared.getToken() else {
            throw APIServiceError.requestFailed(statusCode: 401)
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIServiceError.requestFailed(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 500)
        }
    }

    // 5️⃣ (주의) 모든 알림 삭제
    func deleteAllNotifications() async throws {
        let url = baseURL.appendingPathComponent("/notifications")
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"

        guard let token = TokenManager.shared.getToken() else {
            throw APIServiceError.requestFailed(statusCode: 401)
        }
        request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")

        let (_, response) = try await URLSession.shared.data(for: request)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw APIServiceError.requestFailed(statusCode: (response as? HTTPURLResponse)?.statusCode ?? 500)
        }
    }
}
