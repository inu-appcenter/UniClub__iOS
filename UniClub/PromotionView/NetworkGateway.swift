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

enum GatewayFault: Error {
    case invalidURL
    case networkError(Error)
    case decodingError(Error)
    case serverError(Int)
}

enum NetworkGateway {
    static let baseURL = URL(string: "https://uniclub-server.inuappcenter.kr")!

    // authToken 파라미터가 없는 fetchClubDetail 함수
    static func fetchClubDetail(clubId: Int) async throws -> ClubDetail {
        let url = baseURL.appendingPathComponent("/api/v1/clubs/\(clubId)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Accept")

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
            throw GatewayFault.serverError(httpResponse.statusCode)
        }
            
        do {
            let decoder = JSONDecoder()
            let decodedData = try decoder.decode(ClubDetail.self, from: data)
            return decodedData
        } catch {
            print("Decoding Error: \(error)")
            throw GatewayFault.decodingError(error)
        }
    }

    // authToken 파라미터가 없는 updateClubDetail 함수
    static func updateClubDetail(clubId: Int, clubData: UpdateClubRequest) async throws -> Bool {
        let url = baseURL.appendingPathComponent("/api/v1/clubs/\(clubId)")
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONEncoder().encode(clubData)
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw GatewayFault.networkError(URLError(.badServerResponse))
        }
        
        return (200...299).contains(httpResponse.statusCode)
    }
}
