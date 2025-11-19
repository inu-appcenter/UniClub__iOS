import SwiftUI

struct ClubEditView: View {
    @StateObject private var viewModel = ClubEditViewModel()
    @Environment(\.presentationMode) var presentationMode
    let clubId: Int
    
    @State private var showingYoutubeLinkSheet = false
    @State private var showingInstagramLinkSheet = false
    @State private var showingBannerPicker = false
    @State private var showingProfilePicker = false
    @State private var showingGalleryImagePicker = false
    @State private var tempSelectedImage: UIImage?

    var body: some View {
        ZStack {
            if viewModel.isLoading { ProgressView("로딩 중...") }
            else if let errorMessage = viewModel.errorMessage {
                VStack { Text(errorMessage).padding(); Button("다시 시도") { Task { await viewModel.fetchData(clubId: clubId) } } }
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
        .task { await viewModel.fetchData(clubId: clubId) }
        .navigationTitle("").navigationBarTitleDisplayMode(.inline).navigationBarBackButtonHidden(true)
        .overlay(alignment: .topLeading) {
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "chevron.left").font(.title2).foregroundColor(.black).padding(8).background(Color.white.opacity(0.8)).clipShape(Circle())
            }.padding(.leading, 10).padding(.top, 10)
        }
        .sheet(isPresented: $showingBannerPicker) { ImagePicker(selectedImage: $viewModel.bannerImage) }
        .sheet(isPresented: $showingProfilePicker) { ImagePicker(selectedImage: $viewModel.profileImage) }
        .sheet(isPresented: $showingGalleryImagePicker, onDismiss: addImageToGallery) { ImagePicker(selectedImage: $tempSelectedImage) }
        .sheet(isPresented: $showingYoutubeLinkSheet) { LinkEditSheet(linkType: "유튜브", linkURL: $viewModel.youtubeLink, isPresented: $showingYoutubeLinkSheet) }
        .sheet(isPresented: $showingInstagramLinkSheet) { LinkEditSheet(linkType: "인스타그램", linkURL: $viewModel.instagramLink, isPresented: $showingInstagramLinkSheet) }
    }
    
    private func addImageToGallery() { if let newImage = tempSelectedImage { viewModel.addGalleryImage(newImage) }; tempSelectedImage = nil }
}

struct ClubEditFormView: View {
    @ObservedObject var viewModel: ClubEditViewModel
    @Environment(\.presentationMode) var presentationMode
    @Binding var showingYoutubeLinkSheet: Bool; @Binding var showingInstagramLinkSheet: Bool; @Binding var showingBannerPicker: Bool; @Binding var showingProfilePicker: Bool; @Binding var showingGalleryImagePicker: Bool
    
    var body: some View {
        ZStack(alignment: .bottom) {
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    // 배너
                    Button(action: { showingBannerPicker = true }) {
                        ZStack(alignment: .topTrailing) {
                            if let img = viewModel.bannerImage { Image(uiImage: img).resizable().aspectRatio(contentMode: .fill).frame(height: 200).clipped() }
                            else { Image(systemName: "photo").resizable().aspectRatio(contentMode: .fill).frame(height: 200).clipped().foregroundColor(.gray).background(Color.gray.opacity(0.1)) }
                            Image(systemName: "photo.on.rectangle.angled").font(.title2).foregroundColor(.white).padding(8).background(Color.black.opacity(0.6)).clipShape(Circle()).padding(10)
                        }.overlay(Color.black.opacity(0.3))
                    }
                    // 프로필
                    Button(action: { showingProfilePicker = true }) {
                        ZStack(alignment: .bottomTrailing) {
                            if let img = viewModel.profileImage { Image(uiImage: img).resizable().aspectRatio(contentMode: .fill).frame(width: 100, height: 100).clipShape(Circle()) }
                            else { Image(systemName: "person.circle.fill").resizable().aspectRatio(contentMode: .fill).frame(width: 100, height: 100).clipShape(Circle()).foregroundColor(.gray).background(Color.gray.opacity(0.1)) }
                        }.overlay(Circle().stroke(Color(UIColor.systemBackground), lineWidth: 4))
                    }.offset(y: -50).padding(.leading, 20).padding(.bottom, -50)
                    
                    // 정보 입력
                    VStack(alignment: .leading, spacing: 16) {
                        HStack { TextField("동아리 이름", text: $viewModel.name).font(.title).bold() }
                        HStack(spacing: 12) {
                            LabeledInlineTextField(label: "동아리방", text: $viewModel.location)
                            LabeledInlineTextField(label: "회장", text: $viewModel.presidentName)
                            LabeledInlineTextField(label: "연락처", text: $viewModel.presidentPhone, keyboardType: .phonePad)
                        }
                        TextField("한 줄 소개", text: $viewModel.simpleDescription).font(.headline).padding(.top, 8)
                        
                        HStack {
                            Spacer()
                            Button("지원 링크") { /* 로직은 하단 버튼에서 처리 */ }.font(.caption).bold().padding(.horizontal, 12).padding(.vertical, 6).background(Color.orange.opacity(0.2)).foregroundColor(.orange).cornerRadius(15).disabled(true) // 시각적 요소
                            Button(action: { showingYoutubeLinkSheet = true }) { Image(systemName: "play.rectangle.fill").font(.title).foregroundColor(.red) }
                            Button(action: { showingInstagramLinkSheet = true }) { Image(systemName: "camera.fill").font(.title).foregroundColor(.purple) }
                        }
                    }.padding(.horizontal)
                    
                    Divider().padding(.horizontal)
                    
                    // 모집 정보 (DatePicker 사용)
                    VStack(alignment: .leading, spacing: 8) {
                        Text("모집 정보").font(.headline)
                        DatePicker("모집 시작", selection: $viewModel.startDate, displayedComponents: [.date, .hourAndMinute]).datePickerStyle(.compact)
                        DatePicker("모집 마감", selection: $viewModel.endDate, displayedComponents: [.date, .hourAndMinute]).datePickerStyle(.compact)
                        LabeledDetailTextField(label: "공지", content: $viewModel.notice)
                    }.padding(.horizontal)
                    
                    Divider().padding(.horizontal)
                    
                    // 상세 및 갤러리
                    VStack(alignment: .leading, spacing: 8) {
                        Text("동아리 소개글").font(.headline)
                        TextEditor(text: $viewModel.description).frame(minHeight: 150).padding(4).overlay(RoundedRectangle(cornerRadius: 8).stroke(Color.gray.opacity(0.3))).background(Color.clear)
                        
                        Text("대표이미지").font(.headline).padding(.top)
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack {
                                Button(action: { showingGalleryImagePicker = true }) {
                                    Image(systemName: "plus").font(.title).frame(width: 100, height: 100).background(Color.gray.opacity(0.1)).cornerRadius(10).foregroundColor(.gray)
                                }
                                ForEach(viewModel.galleryImages, id: \.self) { img in
                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: img).resizable().aspectRatio(contentMode: .fill).frame(width: 100, height: 100).cornerRadius(10).clipped()
                                        Button(action: { viewModel.removeGalleryImage(img) }) { Image(systemName: "xmark.circle.fill").foregroundColor(.gray).background(Color.white).clipShape(Circle()) }.offset(x: 5, y: -5)
                                    }
                                }
                            }
                        }
                    }.padding(.horizontal).padding(.bottom, 100)
                }
            }
            .edgesIgnoringSafeArea(.top).background(Color(UIColor.systemBackground))
            
            // 저장 버튼
            Button(action: { Task { let success = await viewModel.saveChanges(); if success { presentationMode.wrappedValue.dismiss() } } }) {
                Text("저장하기").bold().frame(maxWidth: .infinity).padding().background(Color.orange).foregroundColor(.white).cornerRadius(12)
            }.disabled(viewModel.isLoading).padding(.horizontal).padding(.bottom, 10).padding(.top, 10).background(.thinMaterial)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

struct LabeledInlineTextField: View {
    let label: String; @Binding var text: String; var keyboardType: UIKeyboardType = .default
    var body: some View { HStack(spacing: 4) { Text(label).font(.caption).bold().foregroundColor(.gray); TextField("입력", text: $text).font(.caption).foregroundColor(.primary).keyboardType(keyboardType) } }
}
struct LabeledDetailTextField: View {
    let label: String; @Binding var content: String
    var body: some View { HStack(alignment: .top) { Text(label).font(.callout).bold().frame(width: 60, alignment: .leading); TextField("입력", text: $content).font(.callout).foregroundColor(.gray); Spacer() } }
}
struct LinkEditSheet: View {
    let linkType: String; @Binding var linkURL: String; @Binding var isPresented: Bool; @State private var tempLink = ""
    var body: some View { NavigationView { VStack(spacing: 20) { Text("링크 추가").font(.headline).padding(.top); TextField("URL", text: $tempLink).textFieldStyle(.roundedBorder).padding(.horizontal); Spacer() }.onAppear { tempLink = linkURL }.toolbar { ToolbarItem(placement: .navigationBarLeading) { Button("취소") { isPresented = false } }; ToolbarItem(placement: .navigationBarTrailing) { Button("완료") { linkURL = tempLink; isPresented = false } } } } }
}
