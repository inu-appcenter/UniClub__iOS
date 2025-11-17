//import SwiftUI
//
//struct ClubDetailView: View {
//    @StateObject private var viewModel = ClubDetailViewModel()
//    let clubId: Int
//
//    var body: some View {
//        ZStack {
//            if viewModel.isLoading {
//                ProgressView()
//            }
//            else if viewModel.errorMessage != nil {
//                VStack(spacing: 20) {
//                    Text("데이터를 불러오는 데 실패했습니다.")
//                        .font(.headline)
//                    
//                    Button("다시 시도") {
//                        Task { await viewModel.fetchClubData(clubId: clubId) }
//                    }
//                    .buttonStyle(.borderedProminent)
//                }
//                .padding()
//            }
//            else if let club = viewModel.club {
//                ClubContentView(club: club, viewModel: viewModel)
//            }
//        }
//        .task {
//            await viewModel.fetchClubData(clubId: clubId)
//        }
//        .navigationTitle(viewModel.club?.name ?? "")
//        .navigationBarTitleDisplayMode(.inline)
//        .overlay(ToastView(message: $viewModel.toastMessage))
//    }
//}
//
//
//// MARK: - 성공 시 보여줄 콘텐츠 뷰
//struct ClubContentView: View {
//    let club: ClubDetail
//    @ObservedObject var viewModel: ClubDetailViewModel
//    @Environment(\.openURL) var openURL
//    
//    var body: some View {
//        ZStack(alignment: .bottom) {
//            ScrollView {
//                VStack(alignment: .leading, spacing: 16) {
//                    Image(systemName: "photo")
//                        .resizable().aspectRatio(contentMode: .fill)
//                        .frame(height: 250).clipped().foregroundColor(.gray)
//                    
//                    HStack {
//                        Text(club.name).font(.title).bold()
//                        Text(club.status.title).font(.caption).bold().foregroundColor(.white)
//                            .padding(.horizontal, 8).padding(.vertical, 4)
//                            .background(Color.orange).cornerRadius(8)
//                    }
//
//                    HStack(spacing: 12) {
//                        Spacer()
//                        if let url = URL(string: club.youtubeLink), !club.youtubeLink.isEmpty {
//                            Button(action: { openURL(url) }) {
//                                Image(systemName: "play.rectangle.fill").font(.title).foregroundColor(.red)
//                            }
//                        }
//                        if let url = URL(string: club.instagramLink), !club.instagramLink.isEmpty {
//                            Button(action: { openURL(url) }) {
//                                Image(systemName: "camera.fill").font(.title).foregroundColor(.purple)
//                            }
//                        }
//                    }
//                    
//                    Text(club.simpleDescription ?? "한 줄 소개가 없습니다.").font(.headline)
//                    Divider()
//                    Text(club.description)
//                }
//                .padding()
//            }
//            
//            HStack(spacing: 12) {
//                NavigationLink(destination: AskView()) {
//                    Text("질문하기").bold().frame(maxWidth: .infinity).padding()
//                        .background(Color.gray.opacity(0.8)).foregroundColor(.white).cornerRadius(12)
//                }
//                if let url = URL(string: club.applicationFormLink), !club.applicationFormLink.isEmpty {
//                    Button(action: { openURL(url) }) {
//                        Text("지원하기").bold().frame(maxWidth: .infinity).padding()
//                            .background(Color.orange).foregroundColor(.white).cornerRadius(12)
//                    }
//                } else {
//                     Text("지원하기").bold().frame(maxWidth: .infinity).padding()
//                        .background(Color.gray).foregroundColor(.white).cornerRadius(12)
//                }
//            }.padding().background(.thinMaterial)
//        }
//        .toolbar {
//            ToolbarItem(placement: .navigationBarTrailing) {
//                HStack {
//                    Button(action: { Task { await viewModel.toggleFavorite() } }) {
//                        Image(systemName: club.favorite ? "heart.fill" : "heart")
//                            .foregroundColor(club.favorite ? .red : .primary)
//                    }
//                    NavigationLink(destination: ClubEditView(clubId: club.id)) {
//                        Image(systemName: "gearshape")
//                    }
//                }
//            }
//        }
//    }
//}
//
//// MARK: - 토스트 메시지 뷰
//struct ToastView: View {
//    @Binding var message: String?
//    var body: some View {
//        if let msg = message {
//            VStack {
//                Spacer()
//                Text(msg).padding().background(Color.black.opacity(0.7))
//                    .foregroundColor(.white).cornerRadius(15).padding(.bottom, 50)
//            }
//            .transition(.opacity.animation(.easeIn))
//            .onAppear {
//                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                    withAnimation { message = nil }
//                }
//            }
//        }
//    }
//}
//
//// MARK: - 미리보기
//#Preview {
//    NavigationView {
//        ClubDetailView(clubId: 1)
//    }
//}
