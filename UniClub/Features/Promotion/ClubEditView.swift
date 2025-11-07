import SwiftUI

@MainActor
class ClubEditViewModel: ObservableObject {
    @Published var name: String = ""
    @Published var simpleDescription: String = ""
    @Published var description: String = ""
    @Published var location: String = ""
    @Published var presidentName: String = ""
    @Published var presidentPhone: String = ""
    @Published var notice: String = ""
    @Published var recruitmentStatus: RecruitmentStatus = .ACTIVE
    @Published var startTime: String = ""
    @Published var endTime: String = ""
    @Published var applyLink: String = ""
    @Published var youtubeLink: String = ""
    @Published var instagramLink: String = ""
    
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private var clubId: Int?
    
    func fetchData(clubId: Int) async {
        self.clubId = clubId
        isLoading = true
        errorMessage = nil
        
        do {
            let clubDetail = try await NetworkGateway.fetchClubDetail(clubId: clubId)
            
            self.name = clubDetail.name
            self.simpleDescription = clubDetail.simpleDescription ?? ""
            self.description = clubDetail.description
            self.location = clubDetail.location
            self.presidentName = clubDetail.presidentName
            self.presidentPhone = clubDetail.presidentPhone
            self.notice = clubDetail.notice
            self.recruitmentStatus = clubDetail.status
            self.startTime = clubDetail.startTime
            self.endTime = clubDetail.endTime
            // --- 모델의 속성 이름과 일치시키기 ---
            self.applyLink = clubDetail.applicationFormLink
            self.youtubeLink = clubDetail.youtubeLink
            self.instagramLink = clubDetail.instagramLink
        } catch {
            self.errorMessage = "데이터를 불러오지 못했습니다: \(error.localizedDescription)"
        }
        isLoading = false
    }
    
    func saveChanges() async -> Bool {
        guard let clubId = clubId else {
            errorMessage = "동아리 ID가 없습니다."
            return false
        }
        isLoading = true
        errorMessage = nil
        
        let updatedData = UpdateClubRequest(
            name: self.name,
            status: self.recruitmentStatus,
            startTime: self.startTime,
            endTime: self.endTime,
            simpleDescription: self.simpleDescription,
            description: self.description,
            notice: self.notice,
            location: self.location,
            presidentName: self.presidentName,
            presidentPhone: self.presidentPhone,
            youtubeLink: self.youtubeLink,
            instagramLink: self.instagramLink,
            applicationFormLink: self.applyLink
        )
        
        var success = false
        do {
            success = try await NetworkGateway.updateClubDetail(
                clubId: clubId,
                clubData: updatedData
            )
        } catch {
            errorMessage = "저장 중 오류가 발생했습니다: \(error.localizedDescription)"
            success = false
        }
        
        isLoading = false
        if !success && errorMessage == nil {
            errorMessage = "저장에 실패했습니다."
        }
        return success
    }
}


// MARK: - View
struct ClubEditView: View {
    @StateObject private var viewModel = ClubEditViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    let clubId: Int

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
                Form {
                    Section("동아리 대표 정보") {
                        TextField("동아리 이름", text: $viewModel.name)
                        TextField("한 줄 소개", text: $viewModel.simpleDescription)
                        VStack(alignment: .leading) {
                            Text("상세 소개").font(.caption).foregroundColor(.gray)
                            TextEditor(text: $viewModel.description)
                                .frame(height: 200)
                        }
                    }
                    
                    Section("모집 정보") {
                        Picker("모집 상태", selection: $viewModel.recruitmentStatus) {
                            Text("모집중").tag(RecruitmentStatus.ACTIVE)
                            Text("모집 예정").tag(RecruitmentStatus.SCHEDULED)
                            Text("모집 마감").tag(RecruitmentStatus.CLOSED)
                        }
                        .pickerStyle(.segmented)
                        
                        TextField("모집 시작 (YYYY-MM-DDTHH:MM:SS)", text: $viewModel.startTime)
                        TextField("모집 마감 (YYYY-MM-DDTHH:MM:SS)", text: $viewModel.endTime)
                        TextField("공지", text: $viewModel.notice)
                    }
                    
                    Section("상세 정보") {
                        TextField("동아리방 위치", text: $viewModel.location)
                        TextField("회장 이름", text: $viewModel.presidentName)
                        TextField("회장 연락처", text: $viewModel.presidentPhone)
                    }
                    
                    Section("링크 정보") {
                        // --- 바인딩되는 변수명 수정 ---
                        TextField("지원 링크", text: $viewModel.applyLink)
                            .keyboardType(.URL)
                        TextField("유튜브 링크", text: $viewModel.youtubeLink)
                            .keyboardType(.URL)
                        TextField("인스타그램 링크", text: $viewModel.instagramLink)
                            .keyboardType(.URL)
                    }
                }
            }
        }
        .task {
            await viewModel.fetchData(clubId: clubId)
        }
        .navigationTitle("정보 수정")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image(systemName: "chevron.backward").foregroundColor(.black)
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("저장") {
                    Task {
                        let success = await viewModel.saveChanges()
                        if success {
                            presentationMode.wrappedValue.dismiss()
                        }
                    }
                }
                .disabled(viewModel.isLoading)
            }
        }
    }
}

// MARK: - 미리보기
#Preview {
    NavigationView {
        ClubEditView(clubId: 1)
    }
}
