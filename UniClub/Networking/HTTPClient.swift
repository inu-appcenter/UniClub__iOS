//
//  HTTPClient.swift
//  UniClub
//
//  Created by 제욱 on 8/31/25.
//

import Foundation

enum APIError: Error, LocalizedError {
    case badURL
    case badResponse(Int, String)
    case decoding(Error)
    case transport(URLError)
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .badURL: return "잘못된 URL입니다."
        case .badResponse(let code, let body): return "[HTTP \(code)] \(body)"
        case .decoding(let err): return "Decoding error: \(err)"
        case .transport(let err): return "Network error: \(err)"
        case .unknown(let err): return "Unknown error: \(err)"
        }
    }
}

final class HTTPClient {
    static let shared = HTTPClient()
    private init() {}

    var authTokenProvider: () -> String? = { nil }

    func get<T: Decodable>(
        _ path: String,
        query: [URLQueryItem]? = nil,
        headers: [String:String] = [:],
        as: T.Type = T.self
    ) async throws -> T {
        let data = try await getRaw(path, query: query, headers: headers)
        do { return try JSONDecoder().decode(T.self, from: data) }
        catch { throw APIError.decoding(error) }
    }

    func getFlexibleArray<T: Decodable>(
        _ path: String,
        query: [URLQueryItem]? = nil,
        headers: [String:String] = [:],
        as: T.Type = T.self
    ) async throws -> [T] {
        let data = try await getRaw(path, query: query, headers: headers)
        let dec = JSONDecoder()
        if let arr = try? dec.decode([T].self, from: data) { return arr }
        let one = try dec.decode(T.self, from: data)
        return [one]
    }

    func withAuthRetry<T>(
        _ work: @escaping () async throws -> T,
        onUnauthorized: @escaping () async throws -> Void
    ) async throws -> T {
        do { return try await work() }
        catch APIError.badResponse(let status, _) where status == 401 {
            try await onUnauthorized()
            return try await work()
        }
    }

    func getRaw(
        _ path: String,
        query: [URLQueryItem]? = nil,
        headers: [String:String] = [:]
    ) async throws -> Data {
        let url = try makeURL(path, query: query)
        var req = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 15)
        req.httpMethod = "GET"
        req.setValue("application/json", forHTTPHeaderField: "Accept")

        if let token = authTokenProvider(), !token.isEmpty {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        headers.forEach { req.setValue($0.value, forHTTPHeaderField: $0.key) }

        do {
            let (data, resp) = try await URLSession.shared.data(for: req)
            log(req, data: data, resp: resp)
            guard let http = resp as? HTTPURLResponse else {
                throw APIError.badResponse(-1, "Invalid HTTPURLResponse")
            }
            guard (200...299).contains(http.statusCode) else {
                let body = String(data: data, encoding: .utf8) ?? ""
                throw APIError.badResponse(http.statusCode, body)
            }
            return data
        } catch let urlErr as URLError {
            throw APIError.transport(urlErr)
        } catch {
            throw APIError.unknown(error)
        }
    }

    private func makeURL(_ path: String, query: [URLQueryItem]?) throws -> URL {
        guard var url = URL(string: AppConfig.baseURL.absoluteString + (path.hasPrefix("/") ? path : "/"+path)) else {
            throw APIError.badURL
        }
        if let query, var comp = URLComponents(url: url, resolvingAgainstBaseURL: false) {
            comp.queryItems = query
            if let u = comp.url { url = u }
        }
        return url
    }

    private func log(_ req: URLRequest, data: Data?, resp: URLResponse?) {
        print("➡️ \(req.httpMethod ?? "-") \(req.url?.absoluteString ?? "-")")
        print("➡️ Headers:", req.allHTTPHeaderFields ?? [:])   // ← OK (요청 헤더)

        if let body = req.httpBody, let s = String(data: body, encoding: .utf8) {
            print("➡️ Body:", s)
        }

        if let http = resp as? HTTPURLResponse {
            print("⬅️ Status:", http.statusCode)
            print("⬅️ Resp Headers:", http.allHeaderFields)     // ← 여기 오타 수정!
        }

        if let data, let s = String(data: data, encoding: .utf8) {
            print("⬅️ Response Body:", s)
        }
    }

}
