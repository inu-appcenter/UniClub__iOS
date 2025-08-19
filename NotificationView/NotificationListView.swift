import SwiftUI

struct NotificationListView: View {
    // 예시 알림 데이터 (더미 데이터 추가됨)
    let notifications: [Notification] = [
        // MARK: - 안 읽은 알림 (isRead: false)
        Notification(title: "관심 동아리", subtitle: "Appcenter 동아리가 곧 지원마감해요!", time: "30분 전", iconName: "heart.fill", type: .heart, isRead: false),
        Notification(title: "질의 응답", subtitle: "질문에 답변이 도착했어요.", time: "30분 전", iconName: "questionmark.circle.fill", type: .question, isRead: false),
        Notification(title: "새로운 소식", subtitle: "이번 학기 장학금 신청 기간이 시작되었어요.", time: "어제", iconName: "bell.fill", type: .other, isRead: false),
        
        // MARK: - 읽은 알림 (isRead: true)
        Notification(title: "총동연", subtitle: "간식나눔 오후6시에 진행합니다.", time: "30분 전", iconName: "megaphone.fill", type: .announcement, isRead: true),
        Notification(title: "관심 동아리", subtitle: "테니스 동아리 모집이 마감되었습니다.", time: "1일 전", iconName: "heart.fill", type: .heart, isRead: true),
        Notification(title: "질의 응답", subtitle: "새로운 질문에 답변이 달렸습니다.", time: "3일 전", iconName: "questionmark.circle.fill", type: .question, isRead: true),
        Notification(title: "개인 알림", subtitle: "생일 축하 메시지가 도착했어요!", time: "4일 전", iconName: "birthday.cake.fill", type: .other, isRead: true)
    ]
    
    var body: some View {
        NavigationView {
            List {
                // "안 읽은 알림" 섹션
                Section(header: Text("안 읽은 알림")
                                .font(.subheadline)
                                .foregroundColor(.gray)) {
                    ForEach(notifications.filter { !$0.isRead }) { notification in
                        NotificationRow(notification: notification)
                    }
                }
                
                // "읽은 알림" 섹션
                Section(header: Text("읽은 알림")
                                .font(.subheadline)
                                .foregroundColor(.gray)) {
                    ForEach(notifications.filter { $0.isRead }) { notification in
                        NotificationRow(notification: notification)
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationBarTitle("알림", displayMode: .inline)
            .navigationBarItems(leading:
                Button(action: {
                    // 뒤로가기 버튼 액션
                }) {
                    Image(systemName: "chevron.left")
                        .foregroundColor(.black)
                }
            )
        }
    }
}

