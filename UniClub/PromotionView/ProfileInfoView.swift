import SwiftUI
// ProfileData를 별도 파일에서 임포트

struct ProfileInfoView: View {
    // PromotionView에서 전달받을 데이터
    let profileData: ProfileData
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToPromotion = false
    @State private var isFavorite = false // 관심 상태를 추적

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // MARK: 상단 배너 이미지와 프로필 이미지
                    ZStack(alignment: .bottomLeading) {
                        Image("Rectangle 256")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 200)
                            .clipped()
                            .onAppear {
                                if UIImage(named: "Rectangle 256") == nil {
                                    print("Warning: Rectangle 256 이미지가 Assets에 없습니다.")
                                }
                            }
                        
                        HStack {
                            Image("Component 7")
                                .resizable()
                                .frame(width: 80, height: 80)
                                .clipShape(Circle())
                                .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                .padding(.leading, 20)
                                .padding(.bottom, -40)
                                .onAppear {
                                    if UIImage(named: "Component 7") == nil {
                                        print("Warning: Component 7 이미지가 Assets에 없습니다.")
                                    }
                                }
                            Spacer()
                        }
                    }
                    .padding(.bottom, 20)
                    
                    // MARK: 동아리 정보 표시
                    VStack(alignment: .leading, spacing: 10) {
                        HStack {
                            Text(profileData.name.isEmpty ? "이름 없음" : profileData.name)
                                .font(.largeTitle)
                                .fontWeight(.bold)
                            
                            Spacer()
                            
                            Text(profileData.status.isEmpty ? "상태 없음" : profileData.status)
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
                                Text(profileData.room.isEmpty ? "정보 없음" : profileData.room)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(alignment: .leading) {
                                Text("회장").bold()
                                Text(profileData.president.isEmpty ? "정보 없음" : profileData.president)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            
                            VStack(alignment: .leading) {
                                Text("연락처").bold()
                                Text(profileData.contact.isEmpty ? "정보 없음" : profileData.contact)
                                    .foregroundColor(.gray)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                        
                        Divider()
                        
                        Text(profileData.intro.isEmpty ? "소개 없음" : profileData.intro)
                            .foregroundColor(.red)
                            .fontWeight(.medium)
                        
                        Divider()
                        
                        HStack {
                            Text("모집 기간").bold()
                            Spacer()
                            Text(profileData.recruitmentPeriod.isEmpty ? "기간 없음" : profileData.recruitmentPeriod)
                                .foregroundColor(.gray)
                        }
                        HStack {
                            Text("공지").bold()
                            Spacer()
                            Text(profileData.notice.isEmpty ? "공지 없음" : profileData.notice)
                                .foregroundColor(.gray)
                        }
                        
                        Divider()
                        
                        Text("동아리 소개").font(.headline)
                        Text(profileData.description.isEmpty ? "설명 없음" : profileData.description)
                            .foregroundColor(.black)
                    }
                    .padding(.horizontal)
                    
                    // MARK: 썸네일 이미지 표시
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            if profileData.thumbnailImages.isEmpty {
                                Rectangle()
                                    .fill(Color.gray.opacity(0.2))
                                    .frame(width: 110, height: 140)
                                    .cornerRadius(10)
                            } else {
                                ForEach(profileData.thumbnailImages, id: \.self) { imageUrlString in
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
                    // 관심 버튼 (하트 모양)
                    Button(action: {
                        isFavorite.toggle()
                        alertMessage = isFavorite ? "관심에 추가됨" : "관심 목록에서 제외됨"
                        showAlert = true
                    }) {
                        Image(systemName: isFavorite ? "heart.fill" : "heart")
                            .foregroundColor(.red)
                            .imageScale(.large)
                    }
                    
                    // 설정 버튼 (PromotionView로 이동)
                    NavigationLink(
                        destination: PromotionView(),
                        isActive: $navigateToPromotion
                    ) {
                        EmptyView()
                    }
                    Button(action: {
                        navigateToPromotion = true
                    }) {
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

struct ProfileInfoView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileInfoView(
            profileData: ProfileData(
                name: "크레퍼스 (CREPERS)",
                status: "모집중",
                room: "17호관 414호",
                president: "이석준",
                contact: "010-1234-5678",
                intro: "동아리에서 함께 연주하고 추억을 쌓아봐요!",
                recruitmentPeriod: "2025.08.01 - 2025.08.15",
                notice: "모집 마감 임박!",
                description: "저희 동아리는 음악과 열정을 공유하는 커뮤니티입니다. 누구나 환영!",
                thumbnailImages: ["https://example.com/image1.jpg", "https://example.com/image2.jpg"]
            )
        )
    }
}
