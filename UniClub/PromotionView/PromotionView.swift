import SwiftUI
import PhotosUI

// MARK: - PromotionView
struct PromotionView: View {
    @Environment(\.dismiss) var dismiss
    
    let clubId: Int64
    var onSave: (Club) -> Void
    
    @State private var clubName: String = ""
    @State private var clubRoom: String = ""
    @State private var president: String = ""
    @State private var contact: String = ""
    @State private var clubIntro: String = ""
    @State private var recruitmentPeriod: String = ""
    @State private var announcement: String = ""
    @State private var clubDescription: String = ""
    @State private var thumbnailImages: [String] = []
    
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var isLoading: Bool = false
    @State private var errorMessage: String?
    
    @State private var recruitmentStatus: RecruitmentStatus = .recruiting
    
    @State private var profileImage: UIImage? = nil
    @State private var backgroundImage: UIImage? = nil
    @State private var selectedProfilePhoto: PhotosPickerItem? = nil
    @State private var selectedBackgroundPhoto: PhotosPickerItem? = nil
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    ZStack(alignment: .bottomLeading) {
                        PhotosPicker(selection: $selectedBackgroundPhoto, matching: .images) {
                            if let backgroundImage = backgroundImage {
                                Image(uiImage: backgroundImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 200)
                                    .clipped()
                            } else {
                                Image("Rectangle 256")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 200)
                                    .clipped()
                            }
                        }
                        .onChange(of: selectedBackgroundPhoto) { _, newValue in
                            Task {
                                if let data = try? await newValue?.loadTransferable(type: Data.self), let image = UIImage(data: data) {
                                    backgroundImage = image
                                }
                            }
                        }
                        
                        PhotosPicker(selection: $selectedProfilePhoto, matching: .images) {
                            if let profileImage = profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                    .padding(.leading, 20)
                                    .padding(.bottom, -40)
                            } else {
                                Image("Component 7")
                                    .resizable()
                                    .frame(width: 80, height: 80)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                    .padding(.leading, 20)
                                    .padding(.bottom, -40)
                            }
                        }
                        .onChange(of: selectedProfilePhoto) { _, newValue in
                            Task {
                                if let data = try? await newValue?.loadTransferable(type: Data.self), let image = UIImage(data: data) {
                                    profileImage = image
                                }
                            }
                        }
                    }
                    .padding(.bottom, 20)
                    
                    VStack(alignment: .leading, spacing: 8) {
                        HStack(spacing: 10) {
                            TextField("동아리 이름", text: $clubName)
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding(.horizontal, 12)
                                .padding(.vertical, 6)
                                .background(Color.orange)
                                .cornerRadius(12)
                            
                            Button(action: { recruitmentStatus.next() }) {
                                Text(recruitmentStatus.rawValue)
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 4)
                                    .background(Color.black)
                                    .cornerRadius(10)
                            }
                        }
                        
                        HStack {
                            VStack(alignment: .leading) {
                                Text("동아리방").bold()
                                TextField("동아리방 입력", text: $clubRoom)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("회장").bold()
                                TextField("회장 입력", text: $president)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                            Spacer()
                            VStack(alignment: .leading) {
                                Text("연락처").bold()
                                TextField("연락처 입력", text: $contact)
                                    .textFieldStyle(RoundedBorderTextFieldStyle())
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                                    .keyboardType(.phonePad)
                            }
                            Spacer()
                        }
                        .padding(.horizontal)
                        
                        TextField("소개 문구", text: $clubIntro)
                            .foregroundColor(.red)
                            .fontWeight(.medium)
                            .background(Image("Rounded rectangle1").resizable().scaledToFill())
                        
                        VStack(alignment: .leading, spacing: 2) {
                            TextField("모집기간 입력", text: $recruitmentPeriod)
                                .padding(10)
                                .font(.footnote)
                                .foregroundColor(.black)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                            
                            TextField("공지 입력", text: $announcement)
                                .padding(10)
                                .font(.footnote)
                                .foregroundColor(.black)
                                .textFieldStyle(RoundedBorderTextFieldStyle())
                        }
                    }
                    .padding(.horizontal)
                    
                    TextEditor(text: $clubDescription)
                        .font(.body)
                        .foregroundColor(.black)
                        .padding(.horizontal)
                        .frame(minHeight: 150)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray.opacity(0.4), lineWidth: 1)
                        )
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            if thumbnailImages.isEmpty {
                                ForEach(0..<3) { _ in
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 110, height: 140)
                                        .cornerRadius(10)
                                }
                            } else {
                                ForEach(thumbnailImages.indices, id: \.self) { index in
                                    ZStack(alignment: .topTrailing) {
                                        AsyncImage(url: URL(string: thumbnailImages[index])) { image in
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
                                        
                                        Button(action: {
                                            thumbnailImages.remove(at: index)
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.white)
                                                .background(Circle().fill(Color.black.opacity(0.6)))
                                        }
                                        .offset(x: 5, y: -5)
                                    }
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                    
                    PhotosPicker(selection: $selectedPhotos, maxSelectionCount: 3, matching: .images) {
                        HStack {
                            Image(systemName: "plus")
                            Text("이미지 추가")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue.opacity(0.1))
                        .cornerRadius(10)
                    }
                    .padding(.horizontal)
                    .onChange(of: selectedPhotos) { _, newValue in
                        Task {
                            await uploadImages(newValue)
                        }
                    }
                    
                    Button(action: {
                        Task {
                            if let savedData = await saveClubData() {
                                onSave(savedData)
                            }
                        }
                    }) {
                        Image("Frame 22")
                            .resizable()
                            .padding(.horizontal, 120)
                    }
                    .padding(.horizontal)
                }
            }
            .overlay {
                if isLoading {
                    ProgressView()
                }
            }
            .task {
                await fetchClubData()
            }
            .alert(isPresented: .constant(errorMessage != nil)) {
                Alert(title: Text("오류"), message: Text(errorMessage ?? "알 수 없는 오류가 발생했습니다."), dismissButton: .default(Text("확인")) {
                    errorMessage = nil
                })
            }
        }
    }
    
    // MARK: - 서버 연동 함수
    private func fetchClubData() async {
        isLoading = true
        defer { isLoading = false }
        guard let url = URL(string: "https://uniclub-server.inuappcenter.kr/api/v1/clubs/\(clubId)") else {
            errorMessage = "잘못된 URL입니다."
            return
        }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let clubData = try JSONDecoder().decode(Club.self, from: data)
            
            clubName = clubData.name
            if let status = RecruitmentStatus(rawValue: clubData.status) {
                recruitmentStatus = status
            }
            recruitmentPeriod = "\(clubData.startTime) - \(clubData.endTime)"
            announcement = clubData.notice
            president = clubData.presidentName
            contact = clubData.presidentPhone
            clubDescription = clubData.description
            clubIntro = clubData.description
            thumbnailImages = clubData.mediaLinks
        } catch {
            errorMessage = "데이터를 가져오지 못했습니다: \(error.localizedDescription)"
        }
    }
    
    private func saveClubData() async -> Club? {
        isLoading = true
        defer { isLoading = false }
        guard let url = URL(string: "https://uniclub-server.inuappcenter.kr/api/v1/clubs/\(clubId)") else {
            errorMessage = "잘못된 URL입니다."
            return nil
        }
        
        let recruitmentTimes = recruitmentPeriod.split(separator: "-").map { $0.trimmingCharacters(in: .whitespaces) }
        let startTime = recruitmentTimes.first ?? ""
        let endTime = recruitmentTimes.last ?? ""
        
        let clubData = Club(
            name: clubName,
            status: recruitmentStatus.rawValue,
            startTime: startTime,
            endTime: endTime,
            description: clubDescription,
            notice: announcement,
            location: clubRoom,
            presidentName: president,
            presidentPhone: contact,
            youtubeLink: nil,
            instagramLink: nil,
            profileImage: "",
            backgroundImage: "",
            mediaLinks: thumbnailImages
        )
        
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(clubData)
            
            let (responseData, response) = try await URLSession.shared.data(for: request)
            
            if let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) {
                print("데이터 저장 성공")
                return try JSONDecoder().decode(Club.self, from: responseData)
            } else {
                errorMessage = "데이터 저장 실패"
                return nil
            }
        } catch {
            errorMessage = "데이터 저장 중 오류: \(error.localizedDescription)"
            return nil
        }
    }
    
    private func uploadImages(_ photos: [PhotosPickerItem]) async {
        isLoading = true
        defer { isLoading = false }
        
        guard let url = URL(string: "https://your-image-upload-api.com/upload") else {
            errorMessage = "잘못된 이미지 업로드 URL입니다."
            return
        }
        
        for photo in photos {
            do {
                if let data = try await photo.loadTransferable(type: Data.self) {
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    let boundary = UUID().uuidString
                    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
                    
                    var body = Data()
                    body.append("--\(boundary)\r\n".data(using: .utf8)!)
                    body.append("Content-Disposition: form-data; name=\"image\"; filename=\"image.jpg\"\r\n".data(using: .utf8)!)
                    body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
                    body.append(data)
                    body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
                    request.httpBody = body
                    
                    let (responseData, _) = try await URLSession.shared.data(for: request)
                    
                    if let imageUrl = String(data: responseData, encoding: .utf8) {
                        thumbnailImages.append(imageUrl)
                    }
                }
            } catch {
                errorMessage = "이미지 업로드 실패: \(error.localizedDescription)"
            }
        }
    }
}
