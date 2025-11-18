// filepath: /Users/jw/MyDeveloper/iOSProject/UniClub clean/UniClub/UniClub/Features/MyPage/View/MyPageView.swift
//
//  MyPageView.swift
//  UniClub
//  Created by 제욱 on 8/6/25.
//

import SwiftUI

struct MyPageView: View {
    @StateObject private var viewModel: MyPageViewModel

    // Default initializer runs on MainActor so creating the default ViewModel is allowed
    @MainActor
    init() {
        _viewModel = StateObject(wrappedValue: MyPageViewModel())
    }

    // Allow injection for previews / tests
    @MainActor
    init(viewModel: MyPageViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Top HStack: API connection box (70x69) + texts
            HStack(alignment: .center, spacing: 12) {
                ZStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(.secondarySystemBackground))
                        .frame(width: 70, height: 69)

                    // Show loading, profile image, or fallback label
                    if viewModel.isLoading {
                        ProgressView()
                    } else if let url = viewModel.mypage?.profileImageURL {
                        // AsyncImage is available on iOS 15+
                        AsyncImage(url: url) { phase in
                            switch phase {
                            case .empty:
                                ProgressView()
                            case .success(let image):
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 70, height: 69)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            case .failure:
                                Text("API")
                                    .font(.headline)
                            @unknown default:
                                Text("API")
                                    .font(.headline)
                            }
                        }
                    } else {
                        Text("API")
                            .font(.headline)
                    }
                }

                VStack(alignment: .leading, spacing: 4) {
                    if viewModel.mypage == nil {
                        Text("데이터를 불러오는 중입니다")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    } else {
                        // Top-to-bottom: nickname, name, major, studentId
                        Text(viewModel.mypage?.nickname ?? "")
                            .font(.headline)

                        Text(viewModel.mypage?.name ?? "")
                            .font(.subheadline)
                            .foregroundColor(.secondary)

                        if let major = viewModel.mypage?.major, !major.isEmpty {
                            Text(major)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }

                        if let sid = viewModel.mypage?.studentId, !sid.isEmpty {
                            Text(sid)
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                }

                Spacer()
            }
            .padding(.bottom, 8)

            // Show error message if any
            if let err = viewModel.errorMessage {
                Text(err)
                    .foregroundColor(.red)
                    .font(.subheadline)
            }

            Group {
                Text("계정")
                    .font(.custom("NotoSansKR-Bold", size: 17))
                    .foregroundColor(.black)

                NavigationLink(destination: AlarmSettingView()) {
                    Text("알림설정")
                        .font(.custom("NotoSansKR-Medium", size: 14))
                        .foregroundColor(.black)
                }

                NavigationLink(destination: EditProfileView()) {
                    Text("프로필 수정")
                        .font(.custom("NotoSansKR-Medium", size: 14))
                        .foregroundColor(.black)
                }

                Button(action: {
                    // Keep logout as a button (no destination)
                }) {
                    Text("로그아웃")
                        .font(.custom("NotoSansKR-Medium", size: 14))
                        .foregroundColor(.black)
                }
            }

            Divider()

            Group {
                Text("이용안내")
                    .font(.custom("NotoSansKR-Bold", size: 17))
                    .foregroundColor(.black)

                NavigationLink(destination: ContactUsView()) {
                    Text("문의하기")
                        .font(.custom("NotoSansKR-Medium", size: 14))
                        .foregroundColor(.black)
                }

                Button("이용약관") {
                    // TODO: 약관 링크
                }
                .font(.custom("NotoSansKR-Medium", size: 14))
                .foregroundColor(.black)
            }

            Divider()

            Group {
                Text("기타")
                    .font(.custom("NotoSansKR-Bold", size: 17))
                    .foregroundColor(.black)

                NavigationLink(destination: DeleteAccountView()) {
                    Text("계정삭제")
                        .font(.custom("NotoSansKR-Medium", size: 14))
                        .foregroundColor(.black)
                }
            }

            Spacer()
        }
        .padding(.leading, 24)
        .padding(.vertical)
        .navigationTitle("마이페이지")
        .task {
            await viewModel.fetch()
        }
    }
}

#Preview {
    MyPageView(viewModel: MyPageViewModel(service: MockMyPageService()))
}
