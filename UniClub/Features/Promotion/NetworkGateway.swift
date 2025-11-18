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

// DTO (Data Transfer Object) - ID가 없는 응답 처리용
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

enum GatewayFault: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case serverError(Int)
    case serverErrorWithBody(Int, String) // 서버 에러 메시지 포함
}

enum NetworkGateway {
    static let baseURL = URL(string: "https://uniclub-server.inuappcenter.kr")!
    
    // ⭐️ 수정됨: 테스트 토큰 문자열 제거
    // ⚠️ 주의: 앱을 테스트하려면 이 변수에 유효한 "Bearer " 토큰을 붙여넣어야 합니다.
    // ⚠️ (권한이 있는 계정, 예: ROLE_ADMIN 또는 동아리 회장)
    private static let tempAuthToken = "" // "Bearer [여기에 유효한 토큰을 붙여넣으세요]"

    // MARK: - (GET) 동아리 상세 정보 조회
    static func fetchClubDetail(clubId: Int) async throws -> ClubDetail {
        let url = baseURL.appendingPathComponent("/api/v1/clubs/\(clubId)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        
        // ⭐️ 수정됨: 토큰이 있을 때만 헤더 추가
        if !tempAuthToken.isEmpty {
            request.setValue(tempAuthToken, forHTTPHeaderField: "Authorization")
        }

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
            let body = String(data: data, encoding: .utf8) ?? "Unknown Error"
            print("Fetch Error: \(httpResponse.statusCode) - \(body)")
            throw GatewayFault.serverErrorWithBody(httpResponse.statusCode, body)
        }
            
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(ClubDetailResponse.self, from: data)
            
            // ID 주입하여 모델 생성
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
    static func updateClubDetail(clubId: Int, clubData: UpdateClubRequest) async throws -> Bool {
        let url = baseURL.appendingPathComponent("/api/v1/clubs/\(clubId)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // ⭐️ 수정됨: 토큰이 있을 때만 헤더 추가
        if !tempAuthToken.isEmpty {
            request.setValue(tempAuthToken, forHTTPHeaderField: "Authorization")
        }
        
        request.httpBody = try JSONEncoder().encode(clubData)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GatewayFault.networkError(URLError(.badServerResponse))
        }
        
        guard (200...299).contains(httpResponse.statusCode) else {
            let body = String(data: data, encoding: .utf8) ?? "Unknown Error"
            print("Update Error: \(httpResponse.statusCode) - \(body)")
            throw GatewayFault.serverErrorWithBody(httpResponse.statusCode, body)
        }
        
        return true
    }
    
    // MARK: - (POST) 관심 동아리 토글
    static func toggleFavoriteStatus(clubId: Int) async throws -> Bool {
        let url = baseURL.appendingPathComponent("/api/v1/clubs/\(clubId)/favorite")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        // ⭐️ 수정됨: 토큰이 있을 때만 헤더 추가
        if !tempAuthToken.isEmpty {
            request.setValue(tempAuthToken, forHTTPHeaderField: "Authorization")
        }
        
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
            let body = String(data: data, encoding: .utf8) ?? ""
            throw GatewayFault.serverErrorWithBody(httpResponse.statusCode, body)
        }
        
        return true
    }
}
