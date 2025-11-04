//
//  UniClubAPI.swift
//  UniClub
//
//  통합: Main API + Clubs API + 공통 HTTPClient/에러/유틸
//
import Foundation

enum AppConfig {
    static let baseURL = URL(string: "https://uniclub-server.inuappcenter.kr")!
}

enum API {
    enum Main {
        static let banner = "/api/v1/main/banner"   // GET
        static let clubs  = "/api/v1/main/clubs"    // GET
        static let upload = "/api/v1/main/upload"   // POST (미사용)
    }
    enum Clubs {
        static let list = "/api/v1/clubs"           // GET -> ClubListResponse
    }
    
    enum User {
        static let  me = "/api/v1/users/me"
        static let edit = "/api/v1/users/me"
        static let delet = "/api/v1/users"
    }
}

