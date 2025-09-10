import SwiftUI

struct SignUp: View {
    @State private var studentID = ""
    @State private var password = ""
    @State private var name = ""
    @State private var major = "학과를 선택해주세요"
    @State private var isStudentVerified = false

    let majors = ["컴퓨터공학과", "전자공학과", "기계공학과", "디자인학과", "경영학과", "건축학과"]

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
            
                Text("비밀번호를 입력해주세요.")
                    .font(.subheadline)
                    .foregroundColor(.black)
                SecureField("", text: $password)
                    .foregroundColor(.black)
                    .padding(.bottom, 10)
                    .overlay(Divider().background(Color.gray), alignment: .bottom)
                
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
                
                Picker("학과를 선택해주세요", selection: $major) {
                    ForEach(majors, id: \.self) { major in
                        Text(major).tag(major)
                    }
                }
                .pickerStyle(.menu)
                .foregroundColor(.black)
                .padding(.bottom, 10)
                .overlay(Divider().background(isStudentVerified ? Color.gray : Color.clear), alignment: .bottom)
                .disabled(!isStudentVerified)
                
                Spacer()

                if isStudentVerified {
                    Button(action: {
                    }) {
                        Text("다음")
                            .font(.headline)
                            .foregroundColor(.white)
                            .padding()
                            .frame(maxWidth: 150)
                            .background(Color.black)
                            .cornerRadius(10)
                    }
                    .frame(maxWidth: .infinity)
                } else {
                    Button(action: {
                        // 학생 확인 API 호출
                        ApiService.shared.verifyStudent(studentID: studentID, password: password) { result in
                            switch result {
                            case .success(_):
                                self.isStudentVerified = true
                                print("학생 확인 성공")
                            case .failure(let error):
                                print("학생 확인 실패: \(error.localizedDescription)")
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
