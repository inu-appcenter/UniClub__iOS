import Foundation

// PUT 요청에 사용할 Request Body 모델
struct UpdateClubRequest: Codable {
    let name: String
    let status: RecruitmentStatus
    let startTime: String
    let endTime: String
    let simpleDescription: String
    let description: String
    let notice: String
    let location: String
    let presidentName: String
    let presidentPhone: String
    let youtubeLink: String
    let instagramLink: String
    let applicationFormLink: String
}

// ⭐️ 수정됨: 서버 오류 메시지를 담을 케이스 추가
enum GatewayFault: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case serverError(Int) // ⭐️ 상태 코드만
    case serverErrorWithBody(Int, String) // ⭐️ 상태 코드 + 서버 메시지
}

// (ClubDetailResponse DTO... 는 이전과 동일)
fileprivate struct ClubDetailResponse: Codable {
    let name: String
    let role: String?
    let status: RecruitmentStatus
    let startTime: String
    let endTime: String
    let simpleDescription: String?
    let description: String
    var favorite: Bool
    let notice: String
    let location: String
    let presidentName: String
    let presidentPhone: String
    let youtubeLink: String
    let instagramLink: String
    let applicationFormLink: String
    let mediaList: [MediaInfo]
}


enum NetworkGateway {
    static let baseURL = URL(string: "https://uniclub-server.inuappcenter.kr")!
    
    private static let tempAuthToken = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIyMDIxMDEyMjIiLCJhdXRoIjoiUk9MRV9VU0VSIiwiZXhwIjoxNzc4ODkwMzQwfQ.hA8iZi039XN0V_xz0dD5-SbDT9LpHlrfZn2LST_QQok"

    // (fetchClubDetail 함수는 이전과 동일)
    static func fetchClubDetail(clubId: Int) async throws -> ClubDetail {
        let url = baseURL.appendingPathComponent("/api/v1/clubs/\(clubId)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue(tempAuthToken, forHTTPHeaderField: "Authorization")

        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw GatewayFault.networkError(error)
        }
            
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GatewayFault.networkError(URLError(.badServerResponse))
        }
            
        guard (200...299).contains(httpResponse.statusCode) else {
            // ⭐️ 실패 시 응답 바디를 문자열로 변환 시도
            let body = String(data: data, encoding: .utf8) ?? "응답 바디를 읽을 수 없음"
            print("Server Error [\(httpResponse.statusCode)]: \(body)")
            throw GatewayFault.serverErrorWithBody(httpResponse.statusCode, body)
        }
            
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(ClubDetailResponse.self, from: data)
            
            let clubDetail = ClubDetail(
                id: clubId,
                name: decodedData.name,
                role: decodedData.role,
                status: decodedData.status,
                startTime: decodedData.startTime,
                endTime: decodedData.endTime,
                simpleDescription: decodedData.simpleDescription,
                description: decodedData.description,
                favorite: decodedData.favorite,
                notice: decodedData.notice,
                location: decodedData.location,
                presidentName: decodedData.presidentName,
                presidentPhone: decodedData.presidentPhone,
                youtubeLink: decodedData.youtubeLink,
                instagramLink: decodedData.instagramLink,
                applicationFormLink: decodedData.applicationFormLink,
                mediaList: decodedData.mediaList
            )
            return clubDetail
        } catch {
            print("Decoding Error: \(error)")
            throw GatewayFault.decodingError(error)
        }
    }

    // MARK: - (PUT) 동아리 정보 수정
    // ⭐️ 수정됨: 실패 시 서버 오류 메시지(body)를 반환하도록
    static func updateClubDetail(clubId: Int, clubData: UpdateClubRequest) async throws -> Bool {
        let url = baseURL.appendingPathComponent("/api/v1/clubs/\(clubId)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue(tempAuthToken, forHTTPHeaderField: "Authorization")
        
        request.httpBody = try JSONEncoder().encode(clubData)
        
        // ⭐️ data도 함께 받도록 수정
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GatewayFault.networkError(URLError(.badServerResponse))
        }
        
        // ⭐️ 수정됨: 성공(true)이 아닐 경우, 오류 메시지를 포함하여 throw
        guard (200...299).contains(httpResponse.statusCode) else {
            let body = String(data: data, encoding: .utf8) ?? "응답 바디를 읽을 수 없음"
            print("Server Error [\(httpResponse.statusCode)]: \(body)")
            throw GatewayFault.serverErrorWithBody(httpResponse.statusCode, body)
        }
        
        return true // 성공
    }
    
    // (toggleFavoriteStatus 함수는 이전과 동일)
    static func toggleFavoriteStatus(clubId: Int) async throws -> Bool {
        let url = baseURL.appendingPathComponent("/api/v1/clubs/\(clubId)/favorite")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(tempAuthToken, forHTTPHeaderField: "Authorization")
        
        let (data, response): (Data, URLResponse)
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch {
            throw GatewayFault.networkError(error)
        }
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GatewayFault.networkError(URLError(.badServerResponse))
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let body = String(data: data, encoding: .utf8) ?? "응답 바디를 읽을 수 없음"
            print("Server Error [\(httpResponse.statusCode)]: \(body)")
            throw GatewayFault.serverErrorWithBody(httpResponse.statusCode, body)
        }
        
        return true
    }
}
