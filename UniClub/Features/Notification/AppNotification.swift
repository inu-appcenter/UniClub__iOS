import Foundation
import SwiftUI

// 1. ⭐️ 페이지 응답을 위한 래퍼 구조체 (다시 추가)
// 서버가 보내는 JSON 구조와 일치시킴
struct NotificationResponse: Decodable {
    let notifications: [AppNotification]
    let currentPage: Int
    let totalPages: Int
    let totalElements: Int
    let hasNext: Bool

    // ⭐️ 서버의 "notifications" 키를 우리 "notifications" 프로퍼티에 매칭
    enum CodingKeys: String, CodingKey {
        case notifications
        case currentPage
        case totalPages
        case totalElements
        case hasNext
    }
}

// 2. 알림 데이터 모델 (변경 없음)
struct AppNotification: Identifiable, Equatable, Decodable {
    let id: Int
    var title: String
    var message: String
    var iconName: String
    var iconColorName: String
    var timeAgo: String
    var linkText: String?
    var isRead: Bool

    var iconColor: Color {
        switch iconColorName {
        case "red":
            return .red
        case "orange":
            return .orange
        case "gray":
            return Color(red: 170/255, green: 170/255, blue: 170/255)
        default:
            return .primary
        }
    }
}
