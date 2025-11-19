// TokenManager.swift

import Foundation

class TokenManager {
    static let shared = TokenManager()
    
    // ⚠️ 이 부분을 "userAuthToken" 같은 단순한 키로 변경하세요!
    private let tokenKey = "userAuthToken" // UserDefaults 키
    
    private init() {} // 싱글톤 보장
    
    // 1. 로그인 성공 시 토큰 저장
    func saveToken(_ token: String) {
        UserDefaults.standard.set(token, forKey: tokenKey)
    }
    
    // 2. API 호출 시 토큰 읽기
    func getToken() -> String? {
        return UserDefaults.standard.string(forKey: tokenKey)
    }
    
    // 3. 로그아웃 시 토큰 삭제
    func deleteToken() {
        UserDefaults.standard.removeObject(forKey: tokenKey)
    }
}
