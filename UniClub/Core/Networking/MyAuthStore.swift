//
//  MyAuthor.swift
//  UniClub
//
//  Created by 제욱 on 8/31/25.
//

//
//  MyAuthStore.swift
//  UniClub
//
//  개발용 최소 구현:
//  - accessToken을 메모리(UserDefaults 백업)로 보관
//  - HTTPClient.shared.authTokenProvider가 이 값을 읽어 Authorization 자동 주입
//  - refreshIfNeeded()는 출시 단계에서 실제 /auth/refresh 연동으로 교체
//

import Foundation

final class MyAuthStore {
    static let shared = MyAuthStore()
    private init() { loadFromDefaults() }

    // MARK: - Stored tokens (개발용 최소)
    private let accessKey = "uniclub.auth.accessToken"

    /// Bearer 접두사 없는 순수 JWT 문자열
    var accessToken: String? {
        didSet { saveToDefaults() }
    }

    // MARK: - Persistence (개발 편의상 UserDefaults 사용)
    private func saveToDefaults() {
        let ud = UserDefaults.standard
        if let token = accessToken, !token.isEmpty {
            ud.set(token, forKey: accessKey)
        } else {
            ud.removeObject(forKey: accessKey)
        }
    }

    private func loadFromDefaults() {
        accessToken = UserDefaults.standard.string(forKey: accessKey)
    }

    func signOut() {
        accessToken = nil
    }

    // MARK: - Refresh (출시 시 실제 구현으로 교체)
    /// 401 대응용 자리. 출시 때 /auth/refresh 연동으로 교체하세요.
    @discardableResult
    func refreshIfNeeded() async throws -> String? {
        // 예시) 실제 구현:
        // let newAccess = try await AuthService.refresh(using: refreshToken)
        // accessToken = newAccess
        // return newAccess
        return accessToken // 개발 단계에서는 아무것도 안 함
    }
}
