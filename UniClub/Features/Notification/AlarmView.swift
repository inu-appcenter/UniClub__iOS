// AlarmView.swift

import SwiftUI

// MARK: - 2. 메인 알림 화면 뷰
struct AlarmView: View {

    @StateObject private var viewModel = AlarmViewModel()
    @Namespace private var tabAnimation
    
    let backgroundColor = Color(red: 247/255, green: 247/255, blue: 247/255)

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                
                // 1. 탭 바 및 '전체' 버튼 영역
                VStack(spacing: 0) {
                    HStack(alignment: .bottom) {
                        TabBarButton(title: "안읽은 알림", isSelected: viewModel.selectedTab == .unread, animation: tabAnimation) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                viewModel.selectedTab = .unread
                            }
                        }
                        
                        TabBarButton(title: "읽은 알림", isSelected: viewModel.selectedTab == .read, animation: tabAnimation) {
                            withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                viewModel.selectedTab = .read
                            }
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 10)
                        
                    // '전체 읽기' / '전체 삭제' 버튼
                    HStack {
                        Spacer()
                        
                        if viewModel.selectedTab == .unread {
                            Button("전체 읽기") {
                                viewModel.markAllAsRead()
                            }
                            .font(.system(size: 13))
                            .foregroundColor(Color(red: 150/255, green: 150/255, blue: 150/255))
                            .disabled(viewModel.unreadNotifications.isEmpty)
                            
                        } else { // selectedTab == .read
                            Button("전체 삭제") {
                                viewModel.deleteAllReadNotifications()
                            }
                            .font(.system(size: 13))
                            .foregroundColor(Color(red: 150/255, green: 150/255, blue: 150/255))
                            .disabled(viewModel.readNotifications.isEmpty)
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 4)
                    .padding(.bottom, 8)
                }
                .background(backgroundColor)
                
                // 2. 알림 목록
                
                if viewModel.isLoading && viewModel.notifications.isEmpty {
                    ProgressView()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(backgroundColor)
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .font(.callout)
                        .foregroundColor(.gray)
                        .multilineTextAlignment(.center)
                        .padding()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(backgroundColor)
                } else {
                    ScrollView {
                        VStack(spacing: 16) {
                            
                            let currentList = (viewModel.selectedTab == .unread) ? viewModel.unreadNotifications : viewModel.readNotifications
                            
                            if currentList.isEmpty {
                                Text(viewModel.selectedTab == .unread ? "안읽은 알림이 없습니다." : "읽은 알림이 없습니다.")
                                    .foregroundColor(.gray)
                                    .padding(.top, 50)
                            } else {
                                ForEach(currentList) { notification in
                                    NotificationRowView(notification: notification)
                                        .onTapGesture {
                                            viewModel.markAsRead(notificationId: notification.id)
                                        }
                                        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                            Button(role: .destructive) {
                                                viewModel.deleteNotification(notificationId: notification.id)
                                            } label: {
                                                Text("삭제")
                                                    .font(.system(size: 15, weight: .semibold))
                                                    .foregroundColor(.white)
                                            }
                                            .tint(Color(red: 255/255, green: 100/255, blue: 0/255))
                                        }
                                }
                            }
                            Spacer().frame(height: 8)
                        }
                        .padding(.top, 16)
                    }
                    .background(backgroundColor)
                    .contentMargins(.horizontal, 0, for: .scrollContent)
                }
            }
            .navigationTitle("알림")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {}) { // TODO: 뒤로가기 액션
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                }
            }
            .toolbarBackground(backgroundColor, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .background(backgroundColor.ignoresSafeArea())
            .onAppear {
                if viewModel.notifications.isEmpty {
                    Task {
                        await viewModel.fetchNotifications()
                    }
                }
            }
        }
    }
}

// MARK: - 3. 커스텀 탭 버튼 뷰
struct TabBarButton: View {
    let title: String
    let isSelected: Bool
    let animation: Namespace.ID
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 16, weight: isSelected ? .bold : .medium))
                    .foregroundColor(isSelected ? .black : Color(red: 150/255, green: 150/255, blue: 150/255))
                
                if isSelected {
                    Rectangle()
                        .fill(Color(red: 255/255, green: 100/255, blue: 0/255))
                        .frame(height: 2)
                        .matchedGeometryEffect(id: "tab_underline", in: animation)
                } else {
                    Rectangle()
                        .fill(Color.clear)
                        .frame(height: 2)
                }
            }
            .padding(.horizontal, 10)
        }
        .buttonStyle(.plain)
    }
}

// MARK: - 4. 알림 목록의 각 행(Row) 뷰
struct NotificationRowView: View {
    let notification: AppNotification
    private let iconAreaWidth: CGFloat = 24
    private let iconSpacing: CGFloat = 12
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            
            HStack(alignment: .center) {
                Image(systemName: notification.iconName)
                    .font(.system(size: 20))
                    .foregroundColor(notification.iconColor)
                    .frame(width: iconAreaWidth, height: 24)
                
                Text(notification.title)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Color(red: 80/255, green: 80/255, blue: 80/255))
                
                Spacer()
                
                Text(notification.timeAgo)
                    .font(.system(size: 12))
                    .foregroundColor(Color(red: 170/255, green: 170/255, blue: 170/255))
            }
            
            Text(notification.message)
                .font(.system(size: 15))
                .foregroundColor(.black)
                .padding(.leading, iconAreaWidth + iconSpacing)
            
            if let linkText = notification.linkText {
                Text(linkText)
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(Color(red: 255/255, green: 100/255, blue: 0/255))
                    .padding(.leading, iconAreaWidth + iconSpacing)
                    .padding(.top, 2)
            }
        }
        .padding(16)
        .frame(width: 334)
        .background(Color.white)
        .cornerRadius(16)
    }
}

// MARK: - 미리보기
struct AlarmView_Previews: PreviewProvider {
    static var previews: some View {
        AlarmView()
    }
}
