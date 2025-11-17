import SwiftUI

// MARK: - 1. 알림 데이터 모델 정의
struct Notification: Identifiable, Equatable {
    let id = UUID()
    let title: String
    let subtitle: String
    let time: String
    let iconName: String
    let type: NotificationType
    var actionText: String? = nil
    var isRead: Bool
    
    static func == (lhs: Notification, rhs: Notification) -> Bool {
        lhs.id == rhs.id
    }
}

enum NotificationType {
    case heart, question, announcement, schedule, money, other
}

// MARK: - 2. 알림 목록 뷰 (NotificationView)
struct NotificationView: View {
    @State private var notifications: [Notification] = [
        Notification(title: "질의 응답", subtitle: "질문에 답변이 도착했어요.", time: "30분 전", iconName: "questionmark.circle.fill", type: .question, isRead: false),
        Notification(title: "총동연", subtitle: "간식나눔 오후6시에 진행합니다.", time: "30분 전", iconName: "megaphone.fill", type: .announcement, isRead: false),
        Notification(title: "일정", subtitle: "스터디 모임이 10분 후에 시작됩니다.", time: "10분 전", iconName: "calendar", type: .schedule, isRead: false),
        Notification(title: "관심 동아리", subtitle: "Appcenter 동아리가 곧 지원마감해요!", time: "30분 전", iconName: "heart.fill", type: .heart, actionText: "지원하기", isRead: true),
        Notification(title: "결제", subtitle: "배달의 민족 결제가 완료되었습니다.", time: "2시간 전", iconName: "wonsign.circle.fill", type: .money, isRead: true),
        Notification(title: "새로운 소식", subtitle: "이번 학기 장학금 신청 기간이 시작되었어요.", time: "어제", iconName: "bell.fill", type: .other, isRead: true)
    ]
    
    var unreadNotifications: [Notification] {
        notifications.filter { !$0.isRead }
    }
    
    var readNotifications: [Notification] {
        notifications.filter { $0.isRead }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // MARK: - Custom Navigation Bar
                HStack {
                    Button(action: {}) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                    }
                    Spacer()
                    Text("알림")
                        .font(.headline)
                        .fontWeight(.bold)
                    Spacer()
                    Image(systemName: "chevron.left").opacity(0)
                }
                .padding()
                .foregroundColor(.black)
                .background(Color.white)

                // MARK: - Main Content
                if notifications.isEmpty {
                    VStack {
                        Spacer()
                        Text("알림이 없어요.")
                            .foregroundColor(.gray)
                            .font(.headline)
                        Spacer()
                    }
                } else {
                    List {
                        // --- 안 읽은 알림 섹션 ---
                        if !unreadNotifications.isEmpty {
                            Section(header: Text("안 읽은 알림")) {
                                ForEach(unreadNotifications) { notification in
                                    NotificationRow(notification: notification)
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            Button {
                                                deleteNotification(notification)
                                            } label: {
                                                Text("삭제")
                                            }
                                            .tint(.orange)
                                        }
                                }
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets())
                            }
                        }
                        
                        // --- 읽은 알림 섹션 ---
                        if !readNotifications.isEmpty {
                            Section(header: Text("읽은 알림")) {
                                ForEach(readNotifications) { notification in
                                    NotificationRow(notification: notification)
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            Button {
                                                deleteNotification(notification)
                                            } label: {
                                                Text("삭제")
                                            }
                                            .tint(.orange)
                                        }
                                }
                                .listRowSeparator(.hidden)
                                .listRowInsets(EdgeInsets())
                            }
                        }
                    }
                    .listStyle(.plain)
                    .background(Color(.systemGray6))
                    .padding(.horizontal)
                    .listRowSpacing(12)
                }
            }
            .background(Color(.systemGray6).ignoresSafeArea())
            .navigationBarHidden(true)
        }
        .navigationViewStyle(.stack)
    }
    
    private func deleteNotification(_ notification: Notification) {
        withAnimation {
            notifications.removeAll { $0.id == notification.id }
        }
    }
}

// MARK: - 3. 알림 항목 셀 (NotificationRow)
struct NotificationRow: View {
    let notification: Notification
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: notification.iconName)
                .font(.title3)
                .foregroundColor(iconColor)
                .frame(width: 25, alignment: .center)
                .padding(.top, 2)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(alignment: .top) {
                    Text(notification.title)
                        .font(.subheadline)
                        .fontWeight(.bold)
                    Spacer()
                    Text(notification.time)
                        .font(.caption)
                        .foregroundColor(.gray)
                }
                
                Text(notification.subtitle)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if let actionText = notification.actionText {
                    Text(actionText)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .foregroundColor(.orange)
                        .padding(.top, 2)
                }
            }
        }
        .padding()
        .contentShape(Rectangle())
        .background(Color.white)
        .cornerRadius(15)
        .padding(.trailing, 8)
    }
    
    var iconColor: Color {
        switch notification.type {
        case .heart: return .red
        case .question: return .gray
        case .announcement: return .orange
        case .schedule: return .green
        case .money: return .purple
        case .other: return .blue
        }
    }
}

// MARK: - 4. 프리뷰
struct NotificationView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationView()
    }
}
