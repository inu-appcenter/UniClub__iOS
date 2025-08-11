import Foundation

// iTunes API를 통해 음악 데이터를 가져오는 서비스 클래스
class APIService {
    // 검색어로 음악 데이터를 비동기적으로 가져오는 함수
    func fetchMusic(searchTerm: String) async throws -> [MusicItem] {
        // 검색어를 URL 인코딩
        guard let encodedTerm = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://itunes.apple.com/search?media=music&term=\(encodedTerm)") else {
            throw URLError(.badURL)
        }
        
        // URLSession으로 데이터 요청
        let session = URLSession(configuration: .default)
        do {
            let (data, response) = try await session.data(from: url)
            // HTTP 응답 상태 코드 확인
            guard let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            // JSON 데이터를 MusicResponse로 디코딩
            let musicResponse = try JSONDecoder().decode(MusicResponse.self, from: data)
            return musicResponse.results
        } catch {
            // 에러 발생 시 throw
            throw error
        }
    }
}
