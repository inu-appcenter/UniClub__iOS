import SwiftUI

// MARK: - View
struct ClubEditView: View {
    @StateObject private var viewModel = ClubEditViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    let clubId: Int
    
    // 팝업 상태
    @State private var showingYoutubeLinkSheet = false
    @State private var showingInstagramLinkSheet = false

    // ⭐️ 이미지 피커 상태 (단일/갤러리 구분)
    @State private var showingBannerPicker = false
    @State private var showingProfilePicker = false
    @State private var showingGalleryImagePicker = false
    
    // ⭐️ 이미지 피커가 선택한 이미지를 임시 저장
    @State private var tempSelectedImage: UIImage?

    var body: some View {
        ZStack {
            if viewModel.isLoading {
                ProgressView("로딩 중...")
            }
            else if let errorMessage = viewModel.errorMessage {
                VStack(spacing: 20) {
                    Text(errorMessage)
                        .multilineTextAlignment(.center)
                        .padding()
                    Button("다시 시도") {
                        Task {
                            await viewModel.fetchData(clubId: clubId)
                        }
                    }
                }
            } else {
                ClubEditFormView(
                    viewModel: viewModel,
                    showingYoutubeLinkSheet: $showingYoutubeLinkSheet,
                    showingInstagramLinkSheet: $showingInstagramLinkSheet,
                    showingBannerPicker: $showingBannerPicker,
                    showingProfilePicker: $showingProfilePicker,
                    showingGalleryImagePicker: $showingGalleryImagePicker
                )
            }
        }
        .task {
            // 뷰가 로드될 때 ViewModel의 fetchData 실행
            await viewModel.fetchData(clubId: clubId)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .overlay(alignment: .topLeading) {
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.title2)
                    .foregroundColor(.black)
                    .padding(8)
                    .background(Color.white.opacity(0.8))
                    .clipShape(Circle())
            }
            .padding(.leading, 10)
            .padding(.top, 10)
        }
        
        // --- 시트 연결 ---
        .sheet(isPresented: $showingBannerPicker) {
            // ⭐️ 배너 이미지 피커
            ImagePicker(selectedImage: $viewModel.bannerImage)
        }
        .sheet(isPresented: $showingProfilePicker) {
            // ⭐️ 프로필 이미지 피커
            ImagePicker(selectedImage: $viewModel.profileImage)
        }
        .sheet(isPresented: $showingGalleryImagePicker, onDismiss: addImageToGallery) {
            // ⭐️ 갤러리 이미지 피커 (단일 선택 후 배열에 추가)
            ImagePicker(selectedImage: $tempSelectedImage)
        }
        .sheet(isPresented: $showingYoutubeLinkSheet) {
            LinkEditSheet(linkType: "유튜브", linkURL: $viewModel.youtubeLink, isPresented: $showingYoutubeLinkSheet)
        }
        .sheet(isPresented: $showingInstagramLinkSheet) {
            LinkEditSheet(linkType: "인스타그램", linkURL: $viewModel.instagramLink, isPresented: $showingInstagramLinkSheet)
        }
    }
    
    // ⭐️ ImagePicker가 닫힐 때 호출되어 이미지를 갤러리에 추가
    private func addImageToGallery() {
        if let newImage = tempSelectedImage {
            viewModel.addGalleryImage(newImage)
        }
        tempSelectedImage = nil // 임시 이미지 초기화
    }
}

// MARK: - ClubEditFormView
struct ClubEditFormView: View {
    @ObservedObject var viewModel: ClubEditViewModel
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var showingYoutubeLinkSheet: Bool
    @Binding var showingInstagramLinkSheet: Bool
    @Binding var showingBannerPicker: Bool
    @Binding var showingProfilePicker: Bool
    @Binding var showingGalleryImagePicker: Bool // ⭐️ 이름 변경
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    // --- 1. 배너 이미지 ---
                    Button(action: { showingBannerPicker = true }) {
                        ZStack(alignment: .topTrailing) {
                            if let bannerImage = viewModel.bannerImage {
                                Image(uiImage: bannerImage)
                                    .resizable().aspectRatio(contentMode: .fill)
                                    .frame(height: 200).clipped()
                            } else {
                                Image(systemName: "photo")
                                    .resizable().aspectRatio(contentMode: .fill)
                                    .frame(height: 200).clipped().foregroundColor(.gray)
                                    .background(Color.gray.opacity(0.1))
                            }
                            
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.title2)
                                .foregroundColor(.white)
                                .padding(8)
                                .background(Color.black.opacity(0.6))
                                .clipShape(Circle())
                                .padding(10)
                        }
                        .overlay(Color.black.opacity(0.3))
                    }
                    
                    // --- 2. 프로필 이미지 (+ 버튼 제거됨) ---
                    Button(action: { showingProfilePicker = true }) {
                        ZStack(alignment: .bottomTrailing) {
                            if let profileImage = viewModel.profileImage {
                                Image(uiImage: profileImage)
                                    .resizable().aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.circle.fill")
                                    .resizable().aspectRatio(contentMode: .fill)
                                    .frame(width: 100, height: 100)
                                    .clipShape(Circle())
                                    .foregroundColor(.gray)
                                    .background(Color.gray.opacity(0.1))
                            }
                        }
                        .overlay(Circle().stroke(Color(UIColor.systemBackground), lineWidth: 4))
                    }
                    .offset(y: -50)
                    .padding(.leading, 20)
                    .padding(.bottom, -50)
                    
                    
                    // --- 3. 핵심 정보 ---
                    VStack(alignment: .leading, spacing: 16) {
                        
                        // 이름 및 상태
                        HStack(spacing: 8) {
                            TextField("동아리 이름", text: $viewModel.name)
                                .font(.title).bold()
                            Button(action: {
                                switch viewModel.recruitmentStatus {
                                case .ACTIVE: viewModel.recruitmentStatus = .SCHEDULED
                                case .SCHEDULED: viewModel.recruitmentStatus = .CLOSED
                                case .CLOSED: viewModel.recruitmentStatus = .ACTIVE
                                }
                            }) {
                                Text(viewModel.recruitmentStatus.title)
                                    .font(.caption).bold().foregroundColor(.white)
                                    .padding(.horizontal, 8).padding(.vertical, 4)
                                    .background(viewModel.recruitmentStatus == .ACTIVE ? Color.orange : Color.gray)
                                    .cornerRadius(8)
                            }
                        }
                        
                        // 상세 정보
                        HStack(spacing: 12) {
                            LabeledInlineTextField(label: "동아리방", text: $viewModel.location)
                            LabeledInlineTextField(label: "회장", text: $viewModel.presidentName)
                            LabeledInlineTextField(label: "연락처", text: $viewModel.presidentPhone, keyboardType: .phonePad)
                            Spacer()
                        }
                        
                        TextField("동아리를 한 줄로 표현해보세요", text: $viewModel.simpleDescription)
                            .font(.headline).padding(.top, 8)
                        
                        // 링크 버튼
                        HStack(spacing: 12) {
                            Spacer()
                            
                            VStack(alignment: .trailing) {
                                Text("지원 링크").font(.caption).bold().foregroundColor(.orange)
                                TextField("URL", text: $viewModel.applyLink)
                                    .font(.caption).keyboardType(.URL).autocorrectionDisabled(true)
                                    .textInputAutocapitalization(.never).multilineTextAlignment(.trailing)
                            }
                            .frame(width: 100)
                            
                            Button(action: { showingYoutubeLinkSheet = true }) {
                                Image(systemName: "play.rectangle.fill")
                                    .font(.title).foregroundColor(.red)
                            }
                            
                            Button(action: { showingInstagramLinkSheet = true }) {
                                Image(systemName: "camera.fill")
                                    .font(.title).foregroundColor(.purple)
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    Divider().padding(.horizontal)
                    
                    // --- 4. 모집 정보 (⭐️ DatePicker로 수정됨) ---
                    VStack(alignment: .leading, spacing: 8) {
                        Text("모집 정보")
                           .font(.headline)
                        
                        DatePicker("모집 시작", selection: $viewModel.startDate, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                        
                        DatePicker("모집 마감", selection: $viewModel.endDate, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)

                        LabeledDetailTextField(label: "공지", content: $viewModel.notice)
                    }
                    .padding(.horizontal)
                    
                    Divider().padding(.horizontal)
                    
                    // --- 5. 상세 소개 ---
                    VStack(alignment: .leading, spacing: 8) {
                        Text("동아리 소개글").font(.headline)
                        TextEditor(text: $viewModel.description)
                            .frame(minHeight: 150, maxHeight: .infinity)
                            .padding(4)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3), lineWidth: 1))
                            .background(Color.clear)
                    }
                    .padding(.horizontal)
                    
                    Divider().padding(.horizontal)
                    
                    // --- 6. 대표 이미지 (⭐️ 여러 이미지 추가 기능) ---
                    VStack(alignment: .leading, spacing: 10) {
                        Text("대표이미지").font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 10) {
                                // ⭐️ 이미지 추가 버튼
                                Button(action: { showingGalleryImagePicker = true }) {
                                    Image(systemName: "plus")
                                        .font(.title)
                                        .frame(width: 100, height: 100)
                                        .background(Color.gray.opacity(0.1))
                                        .cornerRadius(10)
                                        .foregroundColor(.gray)
                                }
                                
                                // ⭐️ 선택된 이미지 목록
                                ForEach(viewModel.galleryImages, id: \.self) { image in
                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: image)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 100, height: 100)
                                            .cornerRadius(10)
                                            .clipped()
                                        
                                        // ⭐️ 삭제 버튼
                                        Button(action: { viewModel.removeGalleryImage(image) }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .foregroundColor(.gray)
                                                .background(Color.white)
                                                .clipShape(Circle())
                                        }
                                        .offset(x: 5, y: -5)
                                    }
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 100)
                    
                }
            }
            .edgesIgnoringSafeArea(.top)
            .background(Color(UIColor.systemBackground))
            
            // --- 7. 하단 저장 버튼 ---
            Button(action: {
                Task {
                    // ⭐️ 저장 시 Date -> String 변환은 ViewModel이 담당
                    let success = await viewModel.saveChanges()
                    if success {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }) {
                Text("저장하기").bold().frame(maxWidth: .infinity).padding()
                    .background(Color.orange).foregroundColor(.white).cornerRadius(12)
            }
            .disabled(viewModel.isLoading)
            .padding(.horizontal).padding(.bottom, 10).padding(.top, 10)
            .background(.thinMaterial)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}


// MARK: - Helper Views
struct LabeledInlineTextField: View {
    let label: String
    @Binding var text: String
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        HStack(spacing: 4) {
            Text(label).font(.caption).bold().foregroundColor(.gray)
            TextField("입력", text: $text)
                .font(.caption).foregroundColor(.primary)
                .keyboardType(keyboardType).autocorrectionDisabled(true)
        }
    }
}

struct LabeledDetailTextField: View {
    let label: String
    @Binding var content: String
    
    var body: some View {
        HStack(alignment: .top) {
            Text(label).font(.callout).bold().frame(width: 60, alignment: .leading)
            TextField("입력", text: $content)
                .font(.callout).foregroundColor(.gray).autocorrectionDisabled(true)
            Spacer()
        }
    }
}

struct LinkEditSheet: View {
    let linkType: String
    @Binding var linkURL: String
    @Binding var isPresented: Bool
    @State private var tempLink: String = ""
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                Text("링크 추가").font(.headline).padding(.top)
                TextField("URL", text: $tempLink)
                    .keyboardType(.URL).autocapitalization(.none).autocorrectionDisabled(true)
                    .textFieldStyle(.roundedBorder).padding(.horizontal)
                Spacer()
            }
            .onAppear { tempLink = linkURL }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("취소") { isPresented = false }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("완료") {
                        linkURL = tempLink
                        isPresented = false
                    }
                }
            }
        }
    }
}

#Preview {
    NavigationView {
        ClubEditView(clubId: 1)
    }
}
