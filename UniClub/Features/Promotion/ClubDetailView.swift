import SwiftUI

struct ClubDetailView: View {
    @StateObject private var viewModel = ClubDetailViewModel()
    let clubId: Int

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView()
            }
            else if viewModel.errorMessage != nil {
                VStack(spacing: 20) {
                    Text("데이터를 불러오는 데 실패했습니다.")
                        .font(.headline)
                    
                    Button("다시 시도") {
                        Task { await viewModel.fetchClubData(clubId: clubId) }
                    }
                    .buttonStyle(.borderedProminent)
                }
                .padding()
            }
            else if let club = viewModel.club {
                ClubContentView(club: club, viewModel: viewModel)
            }
        }
        .onAppear {
            // 화면에 나타날 때마다 데이터 새로고침 (편집 사항 반영)
            Task {
                await viewModel.fetchClubData(clubId: clubId)
            }
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .overlay(ToastView(message: $viewModel.toastMessage))
    }
}

struct ClubContentView: View {
    let club: ClubDetail
    @ObservedObject var viewModel: ClubDetailViewModel
    @Environment(\.openURL) var openURL
    @Environment(\.presentationMode) var presentationMode
    
    var bannerImage: String? { club.mediaList.first(where: { $0.main })?.mediaLink }
    var profileImage: String? { club.mediaList.first(where: { !$0.main })?.mediaLink }

    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    // 1. 배너
                    ZStack(alignment: .top) {
                        AsyncImage(url: URL(string: bannerImage ?? "")) { image in
                            image.resizable().aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Image(systemName: "photo").resizable().aspectRatio(contentMode: .fill).foregroundColor(.gray)
                        }
                        .frame(height: 220).clipped()
                        .overlay(Color.black.opacity(0.2))

                        // 네비게이션 버튼
                        HStack {
                            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                                Image(systemName: "chevron.left").font(.title3).bold().padding(10).background(Color.black.opacity(0.3)).foregroundColor(.white).clipShape(Circle())
                            }
                            Spacer()
                            Button(action: { Task { await viewModel.toggleFavorite() } }) {
                                Image(systemName: club.favorite ? "heart.fill" : "heart").font(.title3).bold().padding(10).background(Color.black.opacity(0.3)).foregroundColor(club.favorite ? .red : .white).clipShape(Circle())
                            }
                            NavigationLink(destination: ClubEditView(clubId: club.id)) {
                                Image(systemName: "gearshape").font(.title3).bold().padding(10).background(Color.black.opacity(0.3)).foregroundColor(.white).clipShape(Circle())
                            }
                        }
                        .padding(.horizontal, 12).padding(.top, 50)
                    }
                    
                    // 2. 정보
                    VStack(alignment: .leading, spacing: 16) {
                        // 프로필
                        AsyncImage(url: URL(string: profileImage ?? "")) { image in
                            image.resizable().aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Image(systemName: "person.circle.fill").resizable().aspectRatio(contentMode: .fill).foregroundColor(.gray)
                        }
                        .frame(width: 100, height: 100).clipShape(Circle())
                        .overlay(Circle().stroke(Color(UIColor.systemBackground), lineWidth: 4))
                        .offset(y: -50).padding(.bottom, -50)

                        // SNS 링크
                        HStack(spacing: 12) {
                            Spacer()
                            if let url = URL(string: club.youtubeLink), !club.youtubeLink.isEmpty {
                                Button(action: { openURL(url) }) { Image(systemName: "play.rectangle.fill").font(.title).foregroundColor(.red) }
                            }
                            if let url = URL(string: club.instagramLink), !club.instagramLink.isEmpty {
                                Button(action: { openURL(url) }) { Image(systemName: "camera.fill").font(.title).foregroundColor(.purple) }
                            }
                        }

                        // 이름/상태
                        HStack(spacing: 8) {
                            Text(club.name).font(.title).bold()
                            Text(club.status.title).font(.caption).bold().foregroundColor(.white).padding(.horizontal, 8).padding(.vertical, 4).background(club.status == .ACTIVE ? Color.orange : Color.gray).cornerRadius(8)
                            Spacer()
                        }
                        
                        // 상세 정보
                        HStack(spacing: 12) {
                            InfoTag(label: "동아리방", content: club.location)
                            InfoTag(label: "회장", content: club.presidentName)
                            InfoTag(label: "연락처", content: club.presidentPhone)
                            Spacer()
                        }
                        
                        Text(club.simpleDescription ?? "").font(.headline).padding(.top, 8)
                        Divider()

                        // 모집 정보
                        VStack(alignment: .leading, spacing: 8) {
                            DetailInfoRow(label: "모집기간", content: "\(club.startTime) ~ \(club.endTime)")
                            DetailInfoRow(label: "공지", content: club.notice.isEmpty ? "-" : club.notice)
                        }
                        Divider()
                        
                        // 소개글
                        Text("동아리 소개글").font(.headline).padding(.bottom, 4)
                        Text(club.description).font(.body).lineSpacing(5)

                        // 갤러리
                        Text("대표 이미지").font(.headline).padding(.bottom, 4)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                ForEach(club.mediaList, id: \.self) { media in
                                    AsyncImage(url: URL(string: media.mediaLink)) { image in
                                        image.resizable().aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        Image(systemName: "photo").resizable().aspectRatio(contentMode: .fill).foregroundColor(.gray).background(Color.gray.opacity(0.1))
                                    }
                                    .frame(width: 150, height: 150).cornerRadius(10).clipped()
                                }
                            }
                        }
                        .padding(.bottom, 100)
                    }
                    .padding(.horizontal)
                }
            }
            .edgesIgnoringSafeArea(.top)
            .background(Color(UIColor.systemBackground))
            
            // 3. 하단 고정 버튼
            HStack(spacing: 12) {
                // AskView 연결
                NavigationLink(destination: QuestionView()) {
                    Text("질문하기").bold().frame(maxWidth: .infinity).padding().background(Color.gray.opacity(0.8)).foregroundColor(.white).cornerRadius(12)
                }
                
                // 지원하기 링크 연결
                if let url = URL(string: club.applicationFormLink), !club.applicationFormLink.isEmpty {
                    Button(action: { openURL(url) }) {
                        Text("지원하기").bold().frame(maxWidth: .infinity).padding().background(Color.orange).foregroundColor(.white).cornerRadius(12)
                    }
                } else {
                    Text("지원하기").bold().frame(maxWidth: .infinity).padding().background(Color.gray).foregroundColor(.white).cornerRadius(12)
                }
            }
            .padding(.horizontal).padding(.bottom, 10).padding(.top, 10).background(.thinMaterial)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct InfoTag: View {
    let label: String, content: String
    var body: some View { HStack(spacing: 4) { Text(label).font(.caption).bold().foregroundColor(.gray); Text(content).font(.caption).foregroundColor(.primary) } }
}
struct DetailInfoRow: View {
    let label: String, content: String
    var body: some View { HStack(alignment: .top) { Text(label).font(.callout).bold().frame(width: 60, alignment: .leading); Text(content).font(.callout).foregroundColor(.gray); Spacer() } }
}
struct ToastView: View {
    @Binding var message: String?
    var body: some View { if let msg = message { VStack { Spacer(); Text(msg).padding().background(Color.black.opacity(0.7)).foregroundColor(.white).cornerRadius(15).padding(.bottom, 50) }.transition(.opacity.animation(.easeIn)).onAppear { DispatchQueue.main.asyncAfter(deadline: .now() + 2) { withAnimation { message = nil } } } } }
}
