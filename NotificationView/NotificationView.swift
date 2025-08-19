import SwiftUI

// MARK: - 1. 알림 데이터 모델 정의

struct Notification: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let time: String
    let iconName: String
    let type: NotificationType
    var isRead: Bool
}

enum NotificationType {
    case heart
    case question
    case announcement
    case schedule
    case money
    case other
}

// MARK: - 2. 알림 목록 뷰 (NotificationView)

struct NotificationView: View {
    @State private var notifications: [Notification] = [
        // 안 읽은 알림 (isRead: false)
        Notification(title: "관심 동아리", subtitle: "Appcenter 동아리가 곧 지원마감해요!", time: "30분 전", iconName: "heart.fill", type: .heart, isRead: false),
        Notification(title: "질의 응답", subtitle: "질문에 답변이 도착했어요.", time: "30분 전", iconName: "questionmark.circle.fill", type: .question, isRead: false),
        Notification(title: "일정", subtitle: "스터디 모임이 10분 후에 시작됩니다.", time: "10분 전", iconName: "calendar", type: .schedule, isRead: false),
        Notification(title: "결제", subtitle: "배달의 민족 결제가 완료되었습니다.", time: "2시간 전", iconName: "wonsign.circle.fill", type: .money, isRead: false),
        Notification(title: "새로운 소식", subtitle: "이번 학기 장학금 신청 기간이 시작되었어요.", time: "어제", iconName: "bell.fill", type: .other, isRead: false),
        
        // 읽은 알림 (isRead: true)
        Notification(title: "총동연", subtitle: "간식나눔 오후6시에 진행합니다.", time: "30분 전", iconName: "megaphone.fill", type: .announcement, isRead: true),
        Notification(title: "관심 동아리", subtitle: "테니스 동아리 모집이 마감되었습니다.", time: "1일 전", iconName: "heart.fill", type: .heart, isRead: true),
        Notification(title: "질의 응답", subtitle: "새로운 질문에 답변이 달렸습니다.", time: "3일 전", iconName: "questionmark.circle.fill", type: .question, isRead: true),
        Notification(title: "개인 알림", subtitle: "생일 축하 메시지가 도착했어요!", time: "4일 전", iconName: "birthday.cake.fill", type: .other, isRead: true)
    ]
    
    var body: some View {
        NavigationView {
            if notifications.isEmpty {
                VStack {
                    Spacer()
                    Text("알림이 없어요.")
                        .foregroundColor(.gray)
                        .font(.headline)
                        .padding()
                    Spacer()
                }
            } else {
                List {
                    Section(header: Text("안 읽은 알림").font(.subheadline).foregroundColor(.gray)) {
                        ForEach(notifications.filter { !$0.isRead }) { notification in
                            NotificationRow(notification: notification)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        deleteNotification(notification)
                                    } label: {
                                        Text("삭제")
                                    }
                                    .tint(.orange)
                                }
                        }
                    }
                    
                    Section(header: Text("읽은 알림").font(.subheadline).foregroundColor(.gray)) {
                        ForEach(notifications.filter { $0.isRead }) { notification in
                            NotificationRow(notification: notification)
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                    Button(role: .destructive) {
                                        deleteNotification(notification)
                                    } label: {
                                        Text("삭제")
                                    }
                                    .tint(.orange)
                                }
                        }
                    }
                }
                .listStyle(PlainListStyle())
                .padding(.horizontal, -10)
            }
        }
        .navigationBarTitle("알림", displayMode: .inline)
        .navigationBarItems(leading:
            Button(action: { }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
            }
        )
    }
    
    // 알림 삭제 함수
    private func deleteNotification(_ notification: Notification) {
        if let index = notifications.firstIndex(where: { $0.id == notification.id }) {
            notifications.remove(at: index)
        }
    }
}

// MARK: - 3. 알림 항목 셀 (NotificationRow)

struct NotificationRow: View {
    let notification: Notification
    
    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: notification.iconName)
                .foregroundColor(iconColor)
                .padding(.top, 5)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .top) {
                    Text(notification.title)
                        .font(.headline)
                        .bold()
                    Spacer()
                    Text(notification.time)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                Text(notification.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
        }
        .padding(15)
        .background(Color(.systemGray6))
        .cornerRadius(10)
        .padding(.horizontal, 10)
    }
    
    var iconColor: Color {
        switch notification.type {
        case .heart: return .red
        case .question: return .blue
        case .announcement: return .orange
        case .schedule: return .green
        case .money: return .purple
        case .other: return .gray
        }
    }
}

// MARK: - 4. 프리뷰

struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
