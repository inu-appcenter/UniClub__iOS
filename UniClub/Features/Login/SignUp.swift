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
<<<<<<< HEAD:UniClub/Features/Login/SignUp.swift
=======
    
    // 학과 선택 뷰를 띄울지 결정하는 상태 변수
>>>>>>> be26fb7 (promotion view change):login/SignUp.swift
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
                
                Text("이름을 입력해주세요.")
                    .font(.subheadline)
                    .foregroundColor(isStudentVerified ? .black : .gray)
                TextField("이름을 입력해주세요", text: $name)
                    .foregroundColor(.black)
                    .padding(.bottom, 10)
                    .overlay(Divider().background(isStudentVerified ? Color.gray : Color.clear), alignment: .bottom)
                    .disabled(!isStudentVerified)
                
                Text("학과를 선택해주세요.")
                    .font(.subheadline)
                    .foregroundColor(isStudentVerified ? .black : .gray)
                
<<<<<<< HEAD:UniClub/Features/Login/SignUp.swift
                Button(action: {
                    if isStudentVerified {
=======
                // Picker 대신 학과 선택 버튼으로 대체
                Button(action: {
                    if isStudentVerified { // 재학생 인증 후에만 선택 가능
>>>>>>> be26fb7 (promotion view change):login/SignUp.swift
                        showingDepartmentSelection = true
                    }
                }) {
                    HStack {
                        Text(major == "학과를 선택해주세요" ? "학과를 선택해주세요" : major)
                            .foregroundColor(major == "학과를 선택해주세요" ? .gray : .black)
                        Spacer()
<<<<<<< HEAD:UniClub/Features/Login/SignUp.swift
                        Image(systemName: "chevron.down")
=======
                        Image(systemName: "chevron.down") // 드롭다운 화살표 아이콘
>>>>>>> be26fb7 (promotion view change):login/SignUp.swift
                            .foregroundColor(.gray)
                    }
                    .padding(.vertical, 10)
                    .padding(.horizontal, 5)
                    .overlay(Divider().background(isStudentVerified ? Color.gray : Color.clear), alignment: .bottom)
<<<<<<< HEAD:UniClub/Features/Login/SignUp.swift
                }
                .disabled(!isStudentVerified)
                .sheet(isPresented: $showingDepartmentSelection) {
                    DepartmentSelectionView(selectedMajor: $major)
                }
=======
                }
                .disabled(!isStudentVerified) // 재학생 인증되지 않으면 비활성화
                .sheet(isPresented: $showingDepartmentSelection) {
                    // DepartmentSelectionView를 모달로 띄움
                    DepartmentSelectionView(selectedMajor: $major)
                }
>>>>>>> be26fb7 (promotion view change):login/SignUp.swift
                
                Spacer()

                if isStudentVerified {
<<<<<<< HEAD:UniClub/Features/Login/SignUp.swift
                    // TermsOfServiceView로 바인딩 변수 전달
                    NavigationLink(destination: TermsOfServiceView(
                        studentID: studentID,
                        password: password,
                        name: name,
                        major: major,
                        isSignUpLinkActive: $isSignUpLinkActive
                    )) {
=======
                    // 다음 버튼 로직 (학과가 선택되어야 활성화)
                    NavigationLink(destination: TermsOfServiceView(studentID: studentID, password: password, name: name, major: major)) {
>>>>>>> be26fb7 (promotion view change):login/SignUp.swift
                        Text("다음")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 150)
<<<<<<< HEAD:UniClub/Features/Login/SignUp.swift
                            .background(major != "학과를 선택해주세요" ? Color.black : Color.gray)
                            .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(major == "학과를 선택해주세요")
=======
                            .background(major != "학과를 선택해주세요" ? Color.black : Color.gray) // 학과 선택 시 활성화
                            .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(major == "학과를 선택해주세요") // 학과가 선택되지 않으면 비활성화
>>>>>>> be26fb7 (promotion view change):login/SignUp.swift
                } else {
                    Button(action: {
                        self.showVerificationError = false
                        
                        APIService.shared.verifyStudent(studentID: studentID, password: password) { result in
                            switch result {
                            case .success(let response):
                                if response.verification == true {
                                    self.isStudentVerified = true
                                    print("Student verification successful (true)")
                                } else {
                                    print("Student verification failed: Server returned false")
                                    self.isStudentVerified = false
                                    self.studentID = ""
                                    self.password = ""
                                    self.showVerificationError = true
                                }
                                
                            case .failure(let error):
                                self.isStudentVerified = false
                                self.studentID = ""
                                self.password = ""
                                self.showVerificationError = true
                                print("Student verification failed (Network/Decode Error): \(error.localizedDescription)")
                            }
                        }
                    }) {
                        HStack {
                            Text("재학생 확인")
                        }
                        .font(.headline)
                        .foregroundColor(
                            !studentID.isEmpty && !password.isEmpty ? .white : .black
                        )
                        .padding()
                        .frame(maxWidth: 150)
                        .background(
                            !studentID.isEmpty && !password.isEmpty ?
                                Color.black : Color.gray.opacity(0.5)
                        )
                        .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity)
                    .disabled(studentID.isEmpty || password.isEmpty)
                }
            }
            .padding(.horizontal, 30)
        }
    }
}
