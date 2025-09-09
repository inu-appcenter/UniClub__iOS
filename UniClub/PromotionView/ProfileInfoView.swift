import SwiftUI

// MARK: - ProfileInfoView
struct ProfileInfoView: View {
    @Binding var club: Club
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var isFavorite = false
    
    let clubId: Int64
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    ZStack(alignment: .bottomLeading) {
                        AsyncImage(url: URL(string: club.backgroundImage)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .clipped()
                        } placeholder: {
                            Color.gray.opacity(0.2)
                                .frame(height: 200)
                        }
                        
                        HStack {
                            AsyncImage(url: URL(string: club.profileImage)) { image in
                                image
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            } placeholder: {
                                Circle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 80, height: 80)
                            }
                            .padding(.leading, 20)
                            .padding(.bottom, -40)
                            Spacer()
                        }
                    }
                    .padding(.bottom, 20)
                    
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(club.name.isEmpty ? "이름 없음" : club.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            Spacer()
                            Text(club.status.isEmpty ? "상태 없음" : club.status)
                                .font(.caption)
                                .foregroundColor(.white)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.orange)
                                .cornerRadius(10)
                        }
                        .padding(.top, 40)
                        
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text("동아리방").bold()
                                Text(club.location.isEmpty ? "정보 없음" : club.location)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(alignment: .leading) {
                                Text("회장").bold()
                                Text(club.presidentName.isEmpty ? "정보 없음" : club.presidentName)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(alignment: .leading) {
                                Text("연락처").bold()
                                Text(club.presidentPhone.isEmpty ? "정보 없음" : club.presidentPhone)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Divider()
                        
                        Text(club.description.isEmpty ? "소개 없음" : club.description)
                            .foregroundColor(.red)
                            .fontWeight(.medium)
                        
                        Divider()
                        
                        HStack {
                            Text("모집 기간").bold()
                            Spacer()
                            Text("\(club.startTime.isEmpty ? "시작 없음" : club.startTime) - \(club.endTime.isEmpty ? "종료 없음" : club.endTime)")
                                .foregroundColor(.gray)
                        }
                        HStack {
                            Text("공지").bold()
                            Spacer()
                            Text(club.notice.isEmpty ? "공지 없음" : club.notice)
                                .foregroundColor(.gray)
                        }
                        
                        Divider()
                        
                        Text("동아리 소개").font(.headline)
                        Text(club.description.isEmpty ? "설명 없음" : club.description)
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            if club.mediaLinks.isEmpty {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 110, height: 140)
                                    .cornerRadius(10)
                            } else {
                                ForEach(club.mediaLinks, id: \.self) { imageUrlString in
                                    AsyncImage(url: URL(string: imageUrlString)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 110, height: 140)
                                            .clipped()
                                            .cornerRadius(10)
                                    } placeholder: {
                                        ProgressView()
                                            .frame(width: 110, height: 140)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    .frame(height: 160)
                }
            }
            .edgesIgnoringSafeArea(.top)
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(trailing:
                HStack(spacing: 1) {
                    Button(action: {
                        isFavorite.toggle()
                        alertMessage = isFavorite ? "관심에 추가됨" : "관심 목록에서 제외됨"
                        showAlert = true
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                            .imageScale(.large)
                    }
                    
                    NavigationLink(destination: PromotionView(clubId: clubId, onSave: { newClub in
                        self.club = newClub
                    })) {
                        Image(systemName: "gear")
                            .foregroundColor(.gray)
                            .imageScale(.large)
                    }
                }
            )
            .alert(isPresented: $showAlert) {
                Alert(title: Text("알림"), message: Text(alertMessage), dismissButton: .default(Text("확인")))
            }
        }
    }
}

// MARK: - Preview
struct ProfileInfoView_Previews: PreviewProvider {
    static let dummyClub = Club(
        name: "앱센터",
        status: "모집 중",
        startTime: "2024.09.01",
        endTime: "2024.09.15",
        description: "",
        notice: "",
        location: "5호관 502호",
        presidentName: "김민수",
        presidentPhone: "010-1234-5678",
        youtubeLink: "https://www.youtube.com",
        instagramLink: "https://www.instagram.com/iclab_inha/",
        profileImage: "https://example.com/profile_image.png",
        backgroundImage: "https://example.com/background_image.png",
        mediaLinks: [
            "https://example.com/media1.png",
            "https://example.com/media2.png",
            "https://example.com/media3.png"
        ]
    )
    
    static var previews: some View {
        StatefulPreviewWrapper(dummyClub) { club in
            ProfileInfoView(club: club, clubId: 1)
        }
    }
}

struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State var value: Value
    var content: (Binding<Value>) -> Content
    
    var body: some View {
        content($value)
    }
    
    init(_ value: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        self._value = State(wrappedValue: value)
        self.content = content
    }
}
