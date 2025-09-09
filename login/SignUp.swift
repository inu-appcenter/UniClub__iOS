import SwiftUI

// 필요한 파일들을 import 합니다.
// DataModels.swift와 APIService.swift는 별도의 모듈이 아니므로, import 문이 필요하지 않습니다.
// 단, 같은 타겟에 포함되어야 합니다.

struct Signup: View {
    @State private var studentID = ""
    @State private var password = ""
    @State private var name = ""
    @State private var major = "학과를 선택해주세요."
    @State private var isStudentVerified = false
    @State private var isLoading = false
    @State private var alertMessage: String?
    
    let majors = ["컴퓨터공학과", "전자공학과", "기계공학과", "디자인학과", "경영학과", "건축학과"]

    var body: some View {
        NavigationStack {
            ZStack {
                Color(red: 247/255, green: 247/255, blue: 247/255).edgesIgnoringSafeArea(.all)

                VStack(alignment: .leading, spacing: 20) {
                    Text("UniClub")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .foregroundColor(.orange)
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
                    
                    Text("비밀번호를 입력해주세요.")
                        .font(.subheadline)
                        .foregroundColor(.black)
                    SecureField("", text: $password)
                        .foregroundColor(.black)
                        .padding(.bottom, 10)
                        .overlay(Divider().background(Color.gray), alignment: .bottom)

                    Spacer()
                    
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
                        
                    Menu {
                        ForEach(majors, id: \.self) { major in
                            Button(action: {
                                self.major = major
                            }) {
                                Text(major)
                            }
                        }
                    } label: {
                        HStack {
                            Text(major)
                                .foregroundColor(.black)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundColor(.gray)
                        }
                        .padding()
                        .frame(width: 300, height: 40)
                        .background(Color(.systemGray6))
                        .cornerRadius(10)
                    }
                    .disabled(!isStudentVerified)
                        
                    if isStudentVerified {
                        NavigationLink(destination: TermsOfServiceView(
                            signupRequest: SignupRequest(
                                studentId: studentID,
                                password: password,
                                name: name,
                                major: major,
                                personalInfoCollectionAgreement: false,
                                marketingAdvertisement: false,
                                studentVerification: isStudentVerified
                            )
                        )) {
                            Text("다음")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: 150)
                                .background(Color.black)
                                .cornerRadius(10)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.top, 20)
                    } else {
                        Button(action: {
                            Task {
                                await verifyStudent()
                            }
                        }) {
                            HStack {
                                if isLoading {
                                    ProgressView()
                                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                } else {
                                    Text("재학생 확인")
                                        .font(.headline)
                                        .foregroundColor(!studentID.isEmpty && !password.isEmpty ? .white : .black)
                                }
                            }
                            .padding()
                            .frame(maxWidth: 150)
                            .background(!studentID.isEmpty && !password.isEmpty ? Color.black : Color.gray.opacity(0.5))
                            .cornerRadius(10)
                        }
                        .frame(maxWidth: .infinity)
                        .disabled(studentID.isEmpty || password.isEmpty || isLoading)
                        .padding(.top, 20)
                    }
                        
                    Spacer()
                }
                .padding(.horizontal, 30)
                .navigationBarHidden(true)
                .alert(isPresented: .constant(alertMessage != nil)) {
                    Alert(title: Text("알림"), message: Text(alertMessage ?? "오류 발생"), dismissButton: .default(Text("확인")) {
                        alertMessage = nil
                    })
                }
            }
        }
    }
    
    private func verifyStudent() async {
        guard !studentID.isEmpty && !password.isEmpty else {
            alertMessage = "학번과 비밀번호를 입력해주세요."
            return
        }
        
        isLoading = true
        defer { isLoading = false }
        
        let request = StudentVerificationRequest(studentId: studentID, password: password)
        
        do {
            try await APIService.shared.verifyStudent(request: request)
            DispatchQueue.main.async {
                self.isStudentVerified = true
                self.alertMessage = "재학생 인증에 성공했습니다! 이름과 학과를 입력해주세요."
            }
        } catch {
            DispatchQueue.main.async {
                self.alertMessage = error.localizedDescription
            }
        }
    }
}
