import SwiftUI
import Combine

// 뷰모델과 뷰에서 공통으로 사용할 탭 상태
enum SelectedTab {
    case unread, read
}

@MainActor
class AlarmViewModel: ObservableObject {
    
    // MARK: - Properties
    @Published var notifications: [AppNotification] = []
    @Published var selectedTab: SelectedTab = .unread
    @Published var isLoading: Bool = false
    @Published var errorMessage: String? = nil
    
    private let notificationService = NotificationService()

    // MARK: - Computed Properties
    var unreadNotifications: [AppNotification] {
        notifications.filter { !$0.isRead }
            .sorted { $0.timeAgo > $1.timeAgo }
    }
    
    var readNotifications: [AppNotification] {
        notifications.filter { $0.isRead }
            .sorted { $0.timeAgo > $1.timeAgo }
    }

    // MARK: - Network Logic (Fetching)
    
    // ⭐️ 디버깅 버전 ⭐️
    func fetchNotifications() async {
        isLoading = true
        errorMessage = nil
        
        do {
            let fetchedNotifications = try await notificationService.fetchNotifications()
            self.notifications = fetchedNotifications
            
        } catch {
            // ⭐️ 디버깅: 구체적인 에러 메시지를 UI에 표시
            print("--- [ViewModel Error] ---")
            print(error) // 콘솔에도 상세 에러 출력
            
            if let apiError = error as? APIServiceError {
                switch apiError {
                case .invalidURL:
                    self.errorMessage = "Error: Invalid URL"
                case .invalidResponse:
                    self.errorMessage = "Error: Invalid Server Response"
                case .requestFailed(let statusCode):
                    // ⭐️ UI에 상태 코드를 보여줌
                    self.errorMessage = "알림을 불러오는데 실패했습니다. (Status Code: \(statusCode))"
                case .decodingError(let decodingError):
                    self.errorMessage = "데이터 형식이 맞지 않습니다. \n(자세한 내용은 콘솔 확인)"
                    print("ViewModel caught decoding error: \(decodingError)")
                }
            } else {
                self.errorMessage = "알 수 없는 오류가 발생했습니다. \n(\(error.localizedDescription))"
            }
        }
        
        isLoading = false
    }
    
    // MARK: - Helper Functions

    func deleteNotification(notificationId: Int) {
        withAnimation {
            notifications.removeAll { $0.id == notificationId }
        }
        
        Task {
            do {
                try await notificationService.deleteNotification(id: notificationId)
            } catch {
                print("🚨 알림 삭제 실패: \(error)")
                await fetchNotifications() // 롤백
            }
        }
    }
    
    func markAsRead(notificationId: Int) {
        if let index = notifications.firstIndex(where: { $0.id == notificationId && !$0.isRead }) {
            withAnimation {
                notifications[index].isRead = true
            }
            
            Task {
                do {
                    try await notificationService.markAsRead(id: notificationId)
                } catch {
                    print("🚨 알림 읽음 처리 실패: \(error)")
                    withAnimation {
                         notifications[index].isRead = false // 롤백
                    }
                }
            }
        }
    }
    
    func markAllAsRead() {
        withAnimation {
            for index in notifications.indices {
                if !notifications[index].isRead {
                    notifications[index].isRead = true
                }
            }
        }
        
        Task {
            do {
                try await notificationService.markAllAsRead()
            } catch {
                print("🚨 전체 읽음 처리 실패: \(error)")
                await fetchNotifications() // 롤백
            }
        }
    }
    
    func deleteAllReadNotifications() {
        let readNotifIds = notifications.filter { $0.isRead }.map { $0.id }
        withAnimation {
            notifications.removeAll { $0.isRead }
        }
        
        // (비효율적이지만) 순차적으로 개별 삭제 호출
        Task {
             for id in readNotifIds {
                 do {
                     try await notificationService.deleteNotification(id: id)
                 } catch {
                     print("🚨 \(id) 삭제 실패")
                 }
             }
             // 모든 삭제 작업 후 데이터 다시 동기화
             await fetchNotifications()
         }
    }
}
