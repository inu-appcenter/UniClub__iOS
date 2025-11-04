////
////  MyPageView.swift
////  UniClub
////  Created by 제욱 on 8/6/25.
////
//
//import SwiftUI
//
//struct MyPageView: View {
//    @StateObject private var vm = MyPageViewModel()
//    @State private var showLogoutConfirm = false
//    @State private var showDeleteConfirm = false
//
//    var body: some View {
//        NavigationStack {
//            List {
//                // MARK: - 프로필
//                Section {
//                    HStack(spacing: 16) {
//                        AsyncImage(url: vm.profile?.avatarURL) { phase in
//                            switch phase {
//                            case .empty:
//                                ProgressView().frame(width: 72, height: 72)
//                            case .failure(_):
//                                ZStack {
//                                    RoundedRectangle(cornerRadius: 16)
//                                        .fill(Color.gray.opacity(0.12))
//                                    Image(systemName: "person.crop.square")
//                                }
//                                .frame(width: 72, height: 72)
//                            case .success(let image):
//                                image.resizable().scaledToFill()
//                                    .frame(width: 72, height: 72)
//                                    .clipShape(RoundedRectangle(cornerRadius: 16))
//                            @unknown default:
//                                Color.clear.frame(width: 72, height: 72)
//                            }
//                        }
//
//                        VStack(alignment: .leading, spacing: 4) {
//                            // 닉네임(있으면) 크게, 실명은 보조로
//                            Text(vm.profile?.displayName ?? "—")
//                                .font(.title3.weight(.semibold))
//                                .foregroundStyle(.primary)
//
//                            if let realName = vm.profile?.name, realName != vm.profile?.displayName {
//                                Text(realName)
//                                    .font(.subheadline)
//                                    .foregroundStyle(.secondary)
//                            }
//
//                            HStack(spacing: 8) {
//                                if let major = vm.profile?.majorDisplay {
//                                    Text(major)
//                                        .font(.subheadline)
//                                        .foregroundStyle(.secondary)
//                                }
//                                if let year = vm.profile?.entranceYearLabel {
//                                    Text(year)
//                                        .font(.subheadline.weight(.semibold))
//                                        .foregroundStyle(.secondary)
//                                }
//                            }
//                        }
//                        Spacer()
//
//                        // 바로가기: 프로필 수정
//                        NavigationLink {
//                            ProfileEditView(profile: vm.profile)
//                        } label: {
//                            Label("수정", systemImage: "pencil")
//                                .labelStyle(.iconOnly)
//                        }
//                        .buttonStyle(.plain)
//                    }
//                    .padding(.vertical, 4)
//                }
//
//                // MARK: - 계정
//                Section("계정") {
//                    NavigationLink("알림 설정") { NotificationSettingsView() }
//                    Button {
//                        showLogoutConfirm = true
//                    } label: {
//                        HStack {
//                            Text("로그아웃")
//                            Spacer()
//                            Image(systemName: "rectangle.portrait.and.arrow.right")
//                                .foregroundStyle(.secondary)
//                        }
//                    }
//                    .tint(.primary)
//                }
//
//                // MARK: - 이용안내
//                Section("이용안내") {
//                    NavigationLink("문의하기") { InquiryView() }
//                    NavigationLink("이용약관") {
//                        TermsView(text: vm.termsText)
//                            .task { await vm.loadTermsIfNeeded() }
//                    }
//                }
//
//                // MARK: - 기타
//                Section("기타") {
//                    Button(role: .destructive) {
//                        showDeleteConfirm = true
//                    } label: {
//                        Text("계정 삭제")
//                    }
//                }
//            }
//            .listStyle(.insetGrouped)
//            .navigationTitle("마이페이지")
//            .task { await vm.load() }
//            .overlay { if vm.isLoading { ProgressView().controlSize(.large) } }
//            .alert("로그아웃 할까요?", isPresented: $showLogoutConfirm) {
//                Button("취소", role: .cancel) {}
//                Button("로그아웃", role: .destructive) { Task { await vm.logout() } }
//            }
//            .alert("계정을 삭제할까요?", isPresented: $showDeleteConfirm) {
//                Button("취소", role: .cancel) {}
//                Button("삭제", role: .destructive) { Task { await vm.deleteAccount() } }
//            } message: { Text("삭제 시 데이터가 영구 삭제될 수 있습니다.") }
//            .alert("오류", isPresented: .constant(vm.lastError != nil)) {
//                Button("확인") { vm.lastError = nil }
//            } message: {
//                Text(vm.lastError ?? "")
//            }
//        }
//    }
//}
//
//
//#Preview {
//    MyPageView()
//}
//
