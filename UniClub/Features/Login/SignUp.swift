import SwiftUI

struct SignUp: View {
    // login 뷰에서 받을 바인딩 변수
    @Binding var isSignUpLinkActive: Bool
    
    @State private var studentID = ""
    @State private var password = ""
    @State private var name = ""
    @State private var major = "학과를 선택해주세요"
    @State private var isStudentVerified = false
    @State private var showVerificationError = false
    @State private var showingDepartmentSelection = false
    
    var body: some View {
        ZStack {
            Color(red: 247/255, green: 247/255, blue: 247/255).edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .leading, spacing: 20) {
                Text("회원가입")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding(.top, 50)
                
                HStack(spacing: 10) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .foregroundColor(.white)
                    Text("학교 포털 계정을 입력해주세요.")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                .padding()
                .background(Color(red: 255/255, green: 102/255, blue: 0/255))
                .cornerRadius(10)
                
                // MARK: - 학번 입력
                Text("학번을 입력해주세요.")
                    .font(.subheadline)
                    .foregroundColor(.black)
                TextField("", text: $studentID)
                    .foregroundColor(.black)
                    .padding(.bottom, 10)
                    .overlay(Divider().background(Color.gray), alignment: .bottom)
                    .onChange(of: studentID) { _ in
                        showVerificationError = false
                    }
                
                // MARK: - 비밀번호 입력
                Text("비밀번호를 입력해주세요.")
                    .font(.subheadline)
                    .foregroundColor(.black)
                SecureField("", text: $password)
                    .foregroundColor(.black)
                    .padding(.bottom, 10)
                    .overlay(Divider().background(Color.gray), alignment: .bottom)
                    .onChange(of: password) { _ in
                        showVerificationError = false
                    }
                
                if showVerificationError {
                    Text("학번과 비밀번호를 다시 입력해주세요.")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.top, 4)
                }
                
                // MARK: - 이름 입력
                Text("이름을 입력해주세요.")
                    .font(.subheadline)
                    .foregroundColor(isStudentVerified ? .black : .gray)
                TextField("이름을 입력해주세요", text: $name)
                    .foregroundColor(.black)
                    .padding(.bottom, 10)
                    .overlay(Divider().background(isStudentVerified ? Color.gray : Color.clear), alignment: .bottom)
                    .disabled(!isStudentVerified)
                
                // MARK: - 학과 선택 버튼 (View 계층으로 이동)
                Text("학과를 선택해주세요.")
                    .font(.subheadline)
                    .foregroundColor(isStudentVerified ? .black : .gray)
                
                Button(action: {
                    if isStudentVerified {
                        showingDepartmentSelection = true
                    }
                }) {
                    HStack {
                        Text(major == "학과를 선택해주세요" ? "학과를 선택해주세요" : major)
                            .foregroundColor(major == "학과를 선택해주세요" ? .gray : .black)
                        Spacer()
                        Image(systemName: "chevron.down") // 드롭다운 화살표 아이콘
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 5)
                    .overlay(Divider().background(isStudentVerified ? Color.gray : Color.clear), alignment: .bottom)
                }
                .disabled(!isStudentVerified)
                .sheet(isPresented: $showingDepartmentSelection) {
                    // DepartmentSelectionView(selectedMajor: $major)
                    // 주석 해제: 실제 사용시 아래 코드를 쓰세요. 테스트를 위해 Text로 대체함.
                    Text("학과 선택 뷰")
                }
                
                Spacer()
                
                // MARK: - 하단 버튼 영역 (인증 여부에 따른 분기 처리)
                if isStudentVerified {
                    // 1. 인증 완료 시: 다음 버튼 (NavigationLink)
                    NavigationLink(destination:
                        // TermsOfServiceView(...)
                        // 실제 뷰로 교체하세요.
                        Text("약관 동의 뷰")
                    ) {
                        Text("다음")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: .infinity) // 150 -> infinity로 통일하거나 조절
                            .background(major != "학과를 선택해주세요" ? Color.black : Color.gray)
                            .cornerRadius(10)
                    }
                    .disabled(major == "학과를 선택해주세요")
                    
                } else {
                    // 2. 인증 미완료 시: 재학생 확인 버튼
                    Button(action: {
                        self.showVerificationError = false
                        
                        // 실제 API 호출 로직
                        /*
                        APIService.shared.verifyStudent(studentID: studentID, password: password) { result in
                            switch result {
                            case .success(let response):
                                if response.verification == true {
                                    self.isStudentVerified = true
                                } else {
                                    self.isStudentVerified = false
                                    self.showVerificationError = true
                                }
                            case .failure(let error):
                                self.isStudentVerified = false
                                self.showVerificationError = true
                            }
                        }
                        */
                        // 테스트를 위해 강제 true 설정 (실제 코드에선 제거)
                        self.isStudentVerified = true
                    }) {
                        Text("재학생 확인")
                            .font(.headline)
                            .foregroundColor(!studentID.isEmpty && !password.isEmpty ? .white : .black)
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(!studentID.isEmpty && !password.isEmpty ? Color.black : Color.gray.opacity(0.5))
                            .cornerRadius(10)
                    }
                    .disabled(studentID.isEmpty || password.isEmpty)
                }
            }
            .padding(.horizontal, 30) // VStack의 padding
            .padding(.bottom, 20)     // 하단 여백 추가
        }
    }
}
